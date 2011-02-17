require 'active_scaffold_batch'

begin
  ActiveScaffoldAssets.copy_to_public(ActiveScaffoldBatch.root)
rescue
  raise $! unless Rails.env == 'production'
end

ActionView::Base.class_eval do
  include ActiveScaffold::Helpers::UpdateColumnHelpers
  if ActiveScaffold.js_framework == :jquery
    include ActiveScaffold::Helpers::DatepickerUpdateColumnHelpers
  elsif ActiveScaffold.js_framework == :prototype
    include ActiveScaffold::Helpers::CalendarDateSelectUpdateColumnHelpers
  end
  include ActiveScaffold::Helpers::BatchCreateColumnHelpers
end