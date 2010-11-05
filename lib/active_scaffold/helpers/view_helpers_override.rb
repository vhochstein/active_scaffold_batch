ActionView::Base.class_eval do
  include ActiveScaffold::Helpers::UpdateColumnHelpers
  if ActiveScaffold.js_framework == :jquery
    include ActiveScaffold::Helpers::DatepickerUpdateColumnHelpers
  elsif ActiveScaffold.js_framework == :prototype
    include ActiveScaffold::Helpers::CalendarDateSelectUpdateColumnHelpers
  end
end
