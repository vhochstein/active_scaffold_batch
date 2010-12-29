module ActiveScaffold::Actions
  module BatchBase

    def self.included(base)
      base.add_active_scaffold_path File.join(Rails.root, 'vendor', 'plugins', ActiveScaffold::Config::BatchBase.plugin_directory, 'frontends', 'default' , 'views')
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
      do_search if respond_to? :do_search
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
      @batch_successful = error_records.empty? if @batch_successful.nil?
      @batch_successful
    end

    def do_batch
      send("before_do_#{action_name}") if respond_to?("before_do_#{action_name}")
      send("#{action_name}_#{batch_scope.downcase}") if !batch_scope.nil? && respond_to?("#{action_name}_#{batch_scope.downcase}")
      prepare_error_record unless batch_successful?
    end

    def batch_base_respond_to_html
      if respond_to? "#{action_name}_respond_to_html"
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
      if respond_to? "#{action_name}_respond_to_js"
        send("#{action_name}_respond_to_js")
      else  
        render :action => "on_batch_base"
      end
    end

    def batch_base_respond_to_xml
      if respond_to? "#{action_name}_respond_to_xml"
        send("#{action_name}_respond_to_xml")
      else
        render :xml => response_object.to_xml(:only => active_scaffold_config.send(action_name).columns.names), :content_type => Mime::XML, :status => response_status
      end
    end

    def batch_base_respond_to_json
      if respond_to? "#{action_name}_respond_to_json"
        send("#{action_name}_respond_to_json")
      else
        render :text => response_object.to_json(:only => active_scaffold_config.send(action_name).columns.names), :content_type => Mime::JSON, :status => response_status
      end
    end

    def batch_base_respond_to_yaml
      if respond_to? "#{action_name}_respond_to_yaml"
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
