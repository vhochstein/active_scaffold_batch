module ActiveScaffold::Actions
  module BatchDelete

    def self.included(base)
      base.before_filter :batch_delete_authorized_filter, :only => [:batch_delete, :batch_destroy]
      base.verify :method => [:post, :put],
                  :only => :batch_destroy,
                  :redirect_to => { :action => :index }
      base.add_active_scaffold_path File.join(Rails.root, 'vendor', 'plugins', ActiveScaffold::Config::BatchUpdate.plugin_directory, 'frontends', 'default' , 'views')
      base.helper_method :batch_delete_scope
    end

    def batch_delete
      do_batch_delete
      render :action => 'batch_delete'
    end

    def batch_destroy
      return redirect_to(params.merge(:action => :batch_delete)) if request.get?

      do_batch_destroy
      if batch_successful?
        do_search if respond_to? :do_search
        do_list
      end
      respond_to_action(:batch_destroy)
    end

    
    protected
    def batch_delete_scope
      if params[:batch_delete_scope]
        @batch_delete_scope = params[:batch_delete_scope] if ['LISTED', 'MARKED'].include?(params[:batch_delete_scope])
        params.delete :batch_delete_scope
      end if @batch_delete_scope.nil?
      @batch_delete_scope
    end

    def error_records
      @error_records ||= []
    end


    def batch_destroy_respond_to_js
      render(:partial => 'on_batch_destroy')
    end

    def batch_destroy_respond_to_html
      if params[:iframe]=='true' # was this an iframe post ?
        responds_to_parent do
          render :action => 'on_batch_destroy.js', :layout => false
        end
      else # just a regular post
        if batch_successful?
          flash[:info] = as_(:deleted_model, :model => @record.to_label)
        end
        return_to_main
      end
    end

    def batch_destroy_respond_to_js
      render :action => 'on_batch_destroy'
    end

    def batch_destroy_respond_to_xml
      render :xml => response_object.to_xml(:only => active_scaffold_config.batch_delete.columns.names), :content_type => Mime::XML, :status => response_status
    end

    def batch_destroy_respond_to_json
      render :text => response_object.to_json(:only => active_scaffold_config.batch_delete.columns.names), :content_type => Mime::JSON, :status => response_status
    end

    def batch_destroy_respond_to_yaml
      render :text => Hash.from_xml(response_object.to_xml(:only => active_scaffold_config.batch_delete.columns.names)).to_yaml, :content_type => Mime::YAML, :status => response_status
    end

    def do_batch_delete
      self.successful = true
    end

    def do_batch_destroy
      send("batch_destroy_#{batch_update_scope.downcase}") if !batch_update_scope.nil? && respond_to?("batch_update_#{batch_update_scope.downcase}")
      prepare_error_record unless batch_successful?
    end

    # in case of an error we have to prepare @record object to have assigned all
    # defined batch_update values, however, do not set those ones with an override
    # these ones will manage on their own
    def prepare_error_record
    end

    def batch_destroy_listed
      case active_scaffold_config.batch_delete.process_mode
      when :delete then
        each_record_in_scope {|record| batch_destroy_record(record)}
      when :delete_all then
        do_search if respond_to? :do_search
        active_scaffold_config.model.delete_all(all_conditions)
      end
      
    end

    def batch_destroy_marked
      case active_scaffold_config.batch_delete.process_mode
      when :delete then
        active_scaffold_config.model.marked.each {|record| batch_destroy_record(record)}
      when :delete_all then
        active_scaffold_config.model.marked.delete_all
        do_demark_all
      end
    end

    def batch_destroy_record(record)
      if record.authorized_for?(:crud_type => :delete)
        destroy_record(record)
      else
        @batch_successful = false
        # some info that you are not authorized to update this record
      end
    end

    def destroy_record(record)
      @successful = nil
      @record = record

      do_destroy
      if successful?
        @record.marked = false if batch_delete_scope == 'MARKED'
      else
        @batch_successful = false
        error_records << @record
      end
    end

    def batch_successful?
      @batch_successful = error_records.empty? if @batch_successful.nil?
      @batch_successful
    end

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def batch_delete_authorized?(record = nil)
      authorized_for?(:crud_type => :delete)
    end

    private

    def batch_delete_authorized_filter
      link = active_scaffold_config.batch_delete.link || active_scaffold_config.batch_delete.class.link
      raise ActiveScaffold::ActionNotAllowed unless self.send(link.security_method)
    end
    def batch_delete_formats
      (default_formats + active_scaffold_config.formats).uniq
    end
    def batch_destroy_formats
      (default_formats + active_scaffold_config.formats + active_scaffold_config.batch_delete.formats).uniq
    end
  end
end
