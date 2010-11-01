module ActiveScaffold::Actions
  module BatchUpdate
    def self.included(base)
      base.before_filter :batch_update_authorized_filter, :only => [:batch_edit, :batch_update]
      base.verify :method => [:post, :put],
                  :only => :batch_update,
                  :redirect_to => { :action => :index }
    end

    def batch_edit
      do_batch_edit
      respond_to_action(:batch_edit)
    end

    def batch_update
      do_batch_update
      respond_to_action(:batch_update)
    end

    
    protected
    def batch_edit_respond_to_html
      if successful?
        render(:action => 'batch_update')
      else
        return_to_main
      end
    end
    def batch_edit_respond_to_js
      render(:partial => 'batch_update_form')
    end
    def batch_update_respond_to_html
      if params[:iframe]=='true' # was this an iframe post ?
        responds_to_parent do
          render :action => 'on_batch_update.js', :layout => false
        end
      else # just a regular post
        if successful?
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
    def batch_update_respond_to_xml
      render :xml => response_object.to_xml(:only => active_scaffold_config.batch_update.columns.names), :content_type => Mime::XML, :status => response_status
    end
    def batch_update_respond_to_json
      render :text => response_object.to_json(:only => active_scaffold_config.batch_update.columns.names), :content_type => Mime::JSON, :status => response_status
    end
    def batch_update_respond_to_yaml
      render :text => Hash.from_xml(response_object.to_xml(:only => active_scaffold_config.batch_update.columns.names)).to_yaml, :content_type => Mime::YAML, :status => response_status
    end

    def do_batch_edit
    end

    def do_batch_update

    end

    
    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def batch_update_authorized?(record = nil)
      authorized_for?(:crud_type => :update)
    end
    private
    def batch_update_authorized_filter
      link = active_scaffold_config.batch_update.link || active_scaffold_config.batch_update.class.link
      raise ActiveScaffold::ActionNotAllowed unless self.send(link.security_method)
    end
    def batch_edit_formats
      (default_formats + active_scaffold_config.formats).uniq
    end
    def batch_update_formats
      (default_formats + active_scaffold_config.formats + active_scaffold_config.batch_update.formats).uniq
    end
  end
end
