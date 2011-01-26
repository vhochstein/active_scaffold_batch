# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

# Load our overrides
require "#{File.dirname(__FILE__)}/active_scaffold_batch/config/core.rb"

module ActiveScaffoldBatch
  def self.root
    File.dirname(__FILE__) + "/.."
  end
end

module ActiveScaffold
  module Actions
    ActiveScaffold.autoload_subdir('actions', self, File.dirname(__FILE__))
  end

  module Config
    ActiveScaffold.autoload_subdir('config', self, File.dirname(__FILE__))
  end

  module Helpers
    ActiveScaffold.autoload_subdir('helpers', self, File.dirname(__FILE__))
  end
end

ActionView::Base.class_eval do
  include ActiveScaffold::Helpers::UpdateColumnHelpers
  if ActiveScaffold.js_framework == :jquery
    include ActiveScaffold::Helpers::DatepickerUpdateColumnHelpers
  elsif ActiveScaffold.js_framework == :prototype
    include ActiveScaffold::Helpers::CalendarDateSelectUpdateColumnHelpers
  end
end

##
## Run the install assets script, too, just to make sure
## But at least rescue the action in production
##
Rails::Application.initializer("active_scaffold_batch.install_assets", :after => "active_scaffold.install_assets") do
  begin
    ActiveScaffoldAssets.copy_to_public(ActiveScaffoldBatch.root)
  rescue
    raise $! unless Rails.env == 'production'
  end
end unless defined?(ACTIVE_SCAFFOLD_BATCH_INSTALLED) && ACTIVE_SCAFFOLD_BATCH_INSTALLED == :plugin