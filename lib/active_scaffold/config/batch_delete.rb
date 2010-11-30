module ActiveScaffold::Config
  class BatchDelete < ActiveScaffold::Config::Base
    self.crud_type = :delete
    
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
    @@link = ActiveScaffold::DataStructures::ActionLink.new('batch_delete', :label => :batch_delete, :type => :collection, :security_method => :batch_delete_authorized?)

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    # configures how batch updates should be processed
    # :delete => standard activerecord delete including validations
    # :delete_all => updating in one sql call without activerecord instantiation and validation
    cattr_accessor :process_mode
    @@process_mode = :delete


    # instance-level configuration
    # ----------------------------

    # see class accessor
    attr_accessor :process_mode


    # the label= method already exists in the Form base class
    def label(model = nil)
      model ||= @core.label(:count => 2)
      @label ? as_(@label) : as_(:deleted_model, :model => model)
    end
  end
end
