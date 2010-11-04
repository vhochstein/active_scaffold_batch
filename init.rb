# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

# Load our overrides
require "#{File.dirname(__FILE__)}/lib/active_scaffold_batch/config/core.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/config/batch_update.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/actions/batch_update.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/helpers/view_helpers_override.rb"

##
## Run the install script, too, just to make sure
## But at least rescue the action in production
##
begin
  require File.dirname(__FILE__) + '/install'
rescue
  raise $! unless Rails.env == 'production'
end