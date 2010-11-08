module ActiveScaffold
  module Helpers
    module CalendarDateSelectUpdateColumnHelpers
      def active_scaffold_update_calendar_date_select(column, options)
        operator_options = active_scaffold_update_generic_operators + ActiveScaffold::Actions::BatchUpdate::DateOperators.collect {|comp| [as_(comp.downcase.to_sym), comp]}
        tags = []
        tags << select_tag("[record][#{column.name}][operator]",
                options_for_select(operator_options, 'NO_UPDATE'),
                  :id => "#{options[:id]}_operator",
                  :class => "text-input as_update_date_operator")
        tags << active_scaffold_search_date_bridge_calendar_control(column, options, nil, 'value')
        tags << active_scaffold_update_date_bridge_trend_tag(column, options)
        tags.join("&nbsp;").html_safe
      end

      def active_scaffold_update_date_bridge_trend_tag(column, options)
        active_scaffold_date_bridge_trend_tag(column, options,
                                             {:name_prefix => '[record]',
                                              :number_value => nil,
                                              :unit_value => nil,
                                              :show => false})
      end
    end
  end
end
