module ActiveScaffold::Actions
  module BatchBase

    def self.included(base)
      base.add_active_scaffold_path File.join(Rails.root, 'vendor', 'plugins', ActiveScaffold::Config::BatchBase.plugin_directory, 'frontends', 'default' , 'views')
      base.helper_method :batch_scope
    end

    protected

    def batch_action(action = action_name.to_sym)
      process_action_link_action(action_name.to_sym) do
        process_batch
      end
    end

    def process_batch
      do_batch
      if batch_successful?
        do_search if respond_to? :do_search
        do_list
      end  
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
  end
end
