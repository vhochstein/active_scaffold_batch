module ActiveScaffold::Actions
  module BatchBase

    def self.included(base)
      base.add_active_scaffold_path File.join(ActiveScaffold::Config::BatchBase.plugin_directory, 'frontends', 'default' , 'views')
      base.helper_method :batch_scope
    end

    protected

    def batch_action(batch_action = :batch_base)
      process_action_link_action(batch_action) do
        process_batch
      end
    end

    def process_batch
      do_batch
      do_search if respond_to? :do_search, true
      do_list
    end

    def batch_scope
      if params[:batch_scope]
        @batch_scope = params[:batch_scope] if ['LISTED', 'MARKED'].include?(params[:batch_scope])
        params.delete :batch_scope
      end if @batch_scope.nil?
      @batch_scope
    end

    def error_records
      @error_records ||= []
    end

     # in case of an error we have to prepare @record object to have assigned all
    # defined batch_update values, however, do not set those ones with an override
    # these ones will manage on their own
    def prepare_error_record
    end

    def batch_successful?
      error_records.empty?
    end

    def do_batch
      send("before_do_#{action_name}") if respond_to?("before_do_#{action_name}", true)
      send("#{action_name}_#{batch_scope.downcase}") if !batch_scope.nil? && respond_to?("#{action_name}_#{batch_scope.downcase}", true)
      prepare_error_record unless batch_successful?
    end

    def authorized_for_job?(record)
      if record.authorized_for?(:crud_type => active_scaffold_config.send(action_name).crud_type)
        true
      else
        record.errors.add(:base, as_(:no_authorization_for_action, :action => action_name))
        error_records << record
        false
      end
    end

    def batch_base_respond_to_html
      if respond_to? "#{action_name}_respond_to_html", true
        send("#{action_name}_respond_to_html")
      else
        if params[:iframe]=='true' # was this an iframe post ?
          responds_to_parent do
            render :action => 'on_batch_base.js', :layout => false
          end
        else # just a regular post
          if batch_successful?
            flash[:info] = as_(:batch_processing_successful)
          end
          return_to_main
        end
      end
    end

    def batch_base_respond_to_js
      if respond_to? "#{action_name}_respond_to_js", true
        send("#{action_name}_respond_to_js")
      else  
        render :action => "on_batch_base"
      end
    end

    def batch_base_respond_to_xml
      if respond_to? "#{action_name}_respond_to_xml", true
        send("#{action_name}_respond_to_xml")
      else
        render :xml => response_object.to_xml(:only => active_scaffold_config.send(action_name).columns.names), :content_type => Mime::XML, :status => response_status
      end
    end

    def batch_base_respond_to_json
      if respond_to? "#{action_name}_respond_to_json", true
        send("#{action_name}_respond_to_json")
      else
        render :text => response_object.to_json(:only => active_scaffold_config.send(action_name).columns.names), :content_type => Mime::JSON, :status => response_status
      end
    end

    def batch_base_respond_to_yaml
      if respond_to? "#{action_name}_respond_to_yaml", true
        send("#{action_name}_respond_to_yaml")
      else
        render :text => Hash.from_xml(response_object.to_xml(:only => active_scaffold_config.send(action_name).columns.names)).to_yaml, :content_type => Mime::YAML, :status => response_status
      end
    end

    def batch_base_formats
      if respond_to? "#{action_name}_formats"
        send("#{action_name}_formats")
      else
        (default_formats + active_scaffold_config.formats + active_scaffold_config.send(action_name).formats).uniq
      end
    end
  end
end
