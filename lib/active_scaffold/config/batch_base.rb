module ActiveScaffold::Config
  class BatchBase < ActiveScaffold::Config::Base
    def initialize(core_config)
      @core = core_config
    end

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(%{(^.*)/lib/active_scaffold/config/batch_base.rb})[1]
  end
end
