# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

# Load our overrides
require "#{File.dirname(__FILE__)}/active_scaffold_batch/config/core.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/config/batch_update.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/actions/batch_update.rb"
require "#{File.dirname(__FILE__)}/active_scaffold/helpers/view_helpers_override.rb"

module ActiveScaffoldBatch
  def self.root
    File.dirname(__FILE__) + "/.."
  end
end


##
## Run the install assets script, too, just to make sure
## But at least rescue the action in production
##
Rails::Application.initializer("active_scaffold_batch.install_assets") do
  begin
    ActiveScaffoldAssets.copy_to_public(ActiveScaffoldBatch.root)
  rescue
    raise $! unless Rails.env == 'production'
  end
end unless defined?(ACTIVE_SCAFFOLD_BATCH_INSTALLED) && ACTIVE_SCAFFOLD_BATCH_INSTALLED == :plugin