module ActiveScaffold::Config
  class BatchDestroy < ActiveScaffold::Config::Base
    self.crud_type = :delete
    
    def initialize(core_config)
      @core = core_config

      # start with the ActionLink defined globally
      @link = self.class.link
      @action_group = self.class.action_group.clone if self.class.action_group
      @action_group ||= 'collection.batch.destroy'
      @process_mode = self.class.process_mode
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    def self.link
      @@link
    end
    def self.link=(val)
      @@link = val
    end
    @@link = [ ActiveScaffold::DataStructures::ActionLink.new('batch_destroy', :label => :listed, :type => :collection, :method => :delete, :position => false, :crud_type => :delete, :confirm => :are_you_sure_to_delete, :parameters => {:batch_scope => 'LISTED'},:security_method => :batch_destroy_authorized?),
               ActiveScaffold::DataStructures::ActionLink.new('batch_destroy', :label => :marked, :type => :collection, :method => :delete, :position => false, :crud_type => :delete, :confirm => :are_you_sure_to_delete, :parameters => {:batch_scope => 'MARKED'}, :security_method => :batch_destroy_authorized?, :ignore_method => :batch_destroy_marked_ignore?)]

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(%{(^.*)/lib/active_scaffold/config/batch_destroy.rb})[1]

    # configures how batch updates should be processed
    # :delete => standard activerecord delete including validations
    # :delete_all => updating in one sql call without activerecord instantiation and validation
    cattr_accessor :process_mode
    @@process_mode = :delete


    # instance-level configuration
    # ----------------------------

    # see class accessor
    attr_accessor :process_mode

    # the ActionLink for this action
    attr_accessor :link

    # the label= method already exists in the Form base class
    def label(model = nil)
      model ||= @core.label(:count => 2)
      @label ? as_(@label) : as_(:deleted_model, :model => model)
    end

  end
end
