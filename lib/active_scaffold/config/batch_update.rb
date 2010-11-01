module ActiveScaffold::Config
  class BatchUpdate < ActiveScaffold::Config::Form
    self.crud_type = :update
    def initialize(*args)
      super
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

    # instance-level configuration
    # ----------------------------

    # the label= method already exists in the Form base class
    def label(model = nil)
      model ||= @core.label(:count => 2)
      @label ? as_(@label) : as_(:update_model, :model => model)
    end
  end
end
