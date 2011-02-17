module ActiveScaffold::Config
  class BatchCreate < ActiveScaffold::Config::Form
    self.crud_type = :create
    def initialize(*args)
      super
      @process_mode = self.class.process_mode
      @action_group ||= 'collection.batch'
      @list_mode_enabled = self.class.list_mode_enabled
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
    @@link = ActiveScaffold::DataStructures::ActionLink.new('batch_new', :label => :create, :type => :collection, :security_method => :batch_create_authorized?, :ignore_method => :batch_create_ignore?)

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(%{(^.*)/lib/active_scaffold/config/batch_create.rb})[1]

    # configures how batch create should be processed
    # :create => standard activerecord create including validations
    cattr_accessor :process_mode
    @@process_mode = :create

    # you may update all records in list view or all marked records
    # you might disable list mode with this switch if you think it is
    # too "dangerous"
    cattr_accessor :list_mode_enabled
    @@list_mode_enabled = true
    # instance-level configuration
    # ----------------------------

    # see class accessor
    attr_accessor :process_mode

    attr_accessor :list_mode_enabled

    # you may use create_batch to create a record for each record
    # of a belong_to association (reverse must be has_many)
    # eg. player belongs to team
    # you may batch create a player records for a list of teams
    attr_accessor :default_batch_by_column


    # the label= method already exists in the Form base class
    def label(model = nil)
      model ||= @core.label(:count => 2)
      @label ? as_(@label) : as_(:create_model, :model => model)
    end
  end
end
