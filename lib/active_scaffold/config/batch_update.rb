module ActiveScaffold::Config
  class BatchUpdate < ActiveScaffold::Config::Form
    self.crud_type = :update
    def initialize(*args)
      super
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
    @@link = ActiveScaffold::DataStructures::ActionLink.new('batch_edit', :label => :batch_edit, :type => :collection, :security_method => :batch_update_authorized?)

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    # configures how batch updates should be processed
    # :update => standard activerecord update including validations
    # :update_all => updating in one sql call without activerecord instantiation and validation
    cattr_accessor :process_mode
    @@process_mode = :update


    # instance-level configuration
    # ----------------------------

    # see class accessor
    attr_accessor :process_mode


    # the label= method already exists in the Form base class
    def label(model = nil)
      model ||= @core.label(:count => 2)
      @label ? as_(@label) : as_(:update_model, :model => model)
    end
  end
end
