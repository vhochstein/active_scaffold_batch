module ActiveScaffold::Actions
  module BatchUpdate

    GenericOperators = [
      'NO_UPDATE',
      'REPLACE'
    ]
    NumericOperators = [
      'PLUS',
      'MINUS',
      'TIMES',
      'DIVISION'
    ]
    NumericOptions = [
      'ABSOLUTE',
      'PERCENT'
    ]

    DateOperators = [
      'PLUS',
      'MINUS'
    ]
    
    def self.included(base)
      base.before_filter :batch_update_authorized_filter, :only => [:batch_edit, :batch_update]
      base.helper_method :batch_update_values
    end

    def batch_edit
      do_batch_edit
      respond_to_action(:batch_edit)
    end

    def batch_update
      batch_action
    end

    
    protected
    def batch_edit_respond_to_html
      if batch_successful?
        render(:action => 'batch_update')
      else
        return_to_main
      end
    end

    def batch_edit_respond_to_js
      render(:partial => 'batch_update_form')
    end

    def selected_columns
      if @selected_columns.nil?
        @selected_columns = []
        if params[:record] && params[:record].is_a?(Hash)
          params[:record].each do |key, value|
            @selected_columns << key.to_sym if value[:operator] != 'NO_UPDATE'
          end
        end
      end
      @selected_columns
    end

    
    def batch_update_values
      @batch_update_values || {}
    end

    def batch_update_respond_to_html
      if params[:iframe]=='true' # was this an iframe post ?
        responds_to_parent do
          render :action => 'on_batch_update.js', :layout => false
        end
      else # just a regular post
        if batch_successful?
          flash[:info] = as_(:updated_model, :model => @record.to_label)
          return_to_main
        else
          render(:action => 'batch_update')
        end
      end
    end

    def batch_update_respond_to_js
      render :action => 'on_batch_update'
    end

    def do_batch_edit
      self.successful = true
      do_new
    end

    def before_do_batch_update
      update_columns = active_scaffold_config.batch_update.columns
      @batch_update_values = attribute_values_from_params(update_columns, params[:record])
    end

    # in case of an error we have to prepare @record object to have assigned all
    # defined batch_update values, however, do not set those ones with an override
    # these ones will manage on their own
    def prepare_error_record
      do_new
      batch_update_values.each do |attribute, value|
        form_ui = colunm_form_ui(value[:column])
        set_record_attribute(value[:column], attribute, value[:value]) unless form_ui && override_batch_update_value?(form_ui)
      end
    end

    def batch_update_listed
      case active_scaffold_config.batch_update.process_mode
      when :update then
        each_record_in_scope {|record| update_record(record) if authorized_for_job?(record)}
      when :update_all then
        updates = updates_for_update_all
        unless updates.first.empty?
          do_search if respond_to? :do_search
          # all_conditions might fail cause joins are not working in update_all
          active_scaffold_config.model.update_all(updates, all_conditions)
        end
      else
        Rails.logger.error("Unknown process_mode: #{active_scaffold_config.batch_update.process_mode} for action batch_update")
      end
      
    end

    def batch_update_marked
      case active_scaffold_config.batch_update.process_mode
      when :update then
        active_scaffold_config.model.marked.each {|record| update_record(record) if authorized_for_job?(record)}
      when :update_all then
        updates = updates_for_update_all
        unless updates.first.empty?
          active_scaffold_config.model.marked.update_all(updates)
          do_demark_all
        end
      else
        Rails.logger.error("Unknown process_mode: #{active_scaffold_config.batch_update.process_mode} for action batch_update")
      end
    end

    def updates_for_update_all()
      update_all = [[]]
      batch_update_values.each do |attribute, value|
        sql_set, value = get_update_all_attribute(value[:column], attribute, value[:value])
        unless sql_set.nil?
          update_all.first << sql_set
          update_all << value if sql_set.include?('?')
        end
      end
      update_all[0] = update_all.first.join(',')
      update_all
    end

    def update_record(record)
      @successful = nil
      @record = record

      batch_update_values.each do |attribute, value|
        set_record_attribute(value[:column], attribute, value[:value])
      end
      
      update_save({:no_record_param_update => true})
      if successful?
        @record.marked = false if batch_scope == 'MARKED'
      else
        error_records << @record
      end
    end

    def set_record_attribute(column, attribute, value)
      form_ui = colunm_form_ui(column)
      if form_ui && override_batch_update_value?(form_ui)
        @record.send("#{attribute}=", send(override_batch_update_value(form_ui), column, @record, value))
      else
        @record.send("#{attribute}=", value[:operator] == 'NULL' ? nil : value[:value])
      end
    end

    def colunm_form_ui(column)
      form_ui = column.form_ui
      form_ui = column.column.type if form_ui.nil? && column.column
    end

    def get_update_all_attribute(column, attribute, value)
      form_ui = column.form_ui
      form_ui = column.column.type if form_ui.nil? && column.column
      
      if form_ui && override_batch_update_all_value?(form_ui)
        update_value =  send(override_batch_update_all_value(form_ui), column, value)
        if update_value.nil?
          sql_set = nil
        else
          sql_set = "#{attribute} = #{update_value}"
          update_value = nil
        end
      else
        sql_set = "#{attribute} = ?"
        update_value = value[:operator] == 'NULL' ? nil : value[:value]
      end
      
      return sql_set, update_value
    end

    def attribute_values_from_params(columns, attributes)
      values = {}
      attributes = {} unless attributes.is_a?(Hash)
      columns.each :for => new_model, :crud_type => :update, :flatten => true do |column|
        values[column.name] = {:column => column, :value => attributes[column.name].merge(:value => column_value_from_param_value(nil, column, attributes[column.name][:value]))} if selected_columns.include? column.name
      end
      values
    end

    
    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def batch_update_authorized?(record = nil)
      authorized_for?(:crud_type => :update)
    end

    def batch_update_ignore?(record = nil)
      false
    end

    def batch_update_value_for_numeric(column, record, calculation_info)
      current_value = record.send(column.name)
      if ActiveScaffold::Actions::BatchUpdate::GenericOperators.include?(calculation_info[:operator]) || ActiveScaffold::Actions::BatchUpdate::NumericOperators.include?(calculation_info[:operator])
        operand = self.class.condition_value_for_numeric(column, calculation_info[:value])
        operand = current_value / 100 * operand  if calculation_info[:opt] == 'PERCENT'
        case calculation_info[:operator]
        when 'REPLACE' then operand
        when 'NULL' then nil
        when 'PLUS' then current_value.present? ? current_value + operand : nil
        when 'MINUS' then current_value.present? ? current_value - operand : nil
        when 'TIMES' then current_value.present? ? current_value * operand : nil
        when 'DIVISION' then current_value.present? ? current_value / operand : nil
        else
          current_value
        end
      else
        current_value
      end
    end
    alias_method :batch_update_value_for_integer, :batch_update_value_for_numeric
    alias_method :batch_update_value_for_decimal, :batch_update_value_for_numeric
    alias_method :batch_update_value_for_float, :batch_update_value_for_numeric

    def batch_update_all_value_for_numeric(column, calculation_info)
      if ActiveScaffold::Actions::BatchUpdate::GenericOperators.include?(calculation_info[:operator]) || ActiveScaffold::Actions::BatchUpdate::NumericOperators.include?(calculation_info[:operator])
        operand =  active_scaffold_config.model.quote_value(self.class.condition_value_for_numeric(column, calculation_info[:value]))
        if calculation_info[:opt] == 'PERCENT'#
          operand = "#{active_scaffold_config.model.connection.quote_column_name(column.name)} / 100.0 * #{operand}"
        end
        case calculation_info[:operator]
        when 'REPLACE' then operand
        when 'NULL' then active_scaffold_config.model.quote_value(nil)
        when 'PLUS' then "#{active_scaffold_config.model.connection.quote_column_name(column.name)} + #{operand}"
        when 'MINUS' then "#{active_scaffold_config.model.connection.quote_column_name(column.name)} - #{operand}"
        when 'TIMES' then "#{active_scaffold_config.model.connection.quote_column_name(column.name)} * #{operand}"
        when 'DIVISION' then "#{active_scaffold_config.model.connection.quote_column_name(column.name)} / #{operand}"
        else
          nil
        end
      else
        nil
      end
    end
    alias_method :batch_update_all_value_for_integer, :batch_update_all_value_for_numeric
    alias_method :batch_update_all_value_for_decimal, :batch_update_all_value_for_numeric
    alias_method :batch_update_all_value_for_float, :batch_update_all_value_for_numeric

    def batch_update_value_for_date_picker(column, record, calculation_info)
      current_value = record.send(column.name)
      {"number"=>"", "unit"=>"DAYS", "value"=>"November 16, 2010", "operator"=>"REPLACE"}
      if ActiveScaffold::Actions::BatchUpdate::GenericOperators.include?(calculation_info[:operator]) || ActiveScaffold::Actions::BatchUpdate::DateOperators.include?(calculation_info[:operator])
        operand = self.class.condition_value_for_datetime(calculation_info[:value], column.column.type == :date ? :to_date : :to_time)
        case calculation_info[:operator]
        when 'REPLACE' then operand
        when 'NULL' then nil
        when 'PLUS' then
          trend_number = [calculation_info['number'].to_i,  1].max
          current_value.in((trend_number).send(calculation_info['unit'].downcase.singularize.to_sym))
        when 'MINUS' then
          trend_number = [calculation_info['number'].to_i,  1].max
          current_value.ago((trend_number).send(calculation_info['unit'].downcase.singularize.to_sym))
        else
          current_value
        end
      else
        current_value
      end
    end
    alias_method :batch_update_value_for_calendar_date_select, :batch_update_value_for_date_picker



    def override_batch_update_value?(form_ui)
      respond_to?(override_batch_update_value(form_ui))
    end

    def override_batch_update_value(form_ui)
      "batch_update_value_for_#{form_ui}"
    end

    def override_batch_update_all_value?(form_ui)
      respond_to?(override_batch_update_all_value(form_ui))
    end

    def override_batch_update_all_value(form_ui)
      "batch_update_all_value_for_#{form_ui}"
    end

    private

    def batch_update_authorized_filter
      link = active_scaffold_config.batch_update.link || active_scaffold_config.batch_update.class.link
      raise ActiveScaffold::ActionNotAllowed unless self.send(link.security_method)
    end
    def batch_edit_formats
      (default_formats + active_scaffold_config.formats).uniq
    end
  end
end
