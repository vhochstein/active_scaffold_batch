module ActiveScaffold
  module Helpers
    module DatepickerUpdateColumnHelpers
      def active_scaffold_update_date_picker(column, options)
        current_params = {:value => nil, :number => nil, :unit => nil, :operator => 'NO_UPDATE'}
        current_params.merge!(batch_update_values[column.name][:value].symbolize_keys) if batch_update_values[column.name] && batch_update_values[column.name][:value]
        operator_options = active_scaffold_update_generic_operators(column)
        operator_options.concat(ActiveScaffold::Actions::BatchUpdate::DateOperators.collect {|comp| [as_(comp.downcase.to_sym), comp]}) if active_scaffold_config.batch_update.process_mode == :update
        options = options.merge(:show => ['PLUS', 'MINUS'].exclude?(current_params[:operator]))
        tags = []
        tags << select_tag("[record][#{column.name}][operator]",
                options_for_select(operator_options, current_params[:operator]),
                  :id => "#{options[:id]}_operator",
                  :class => "text-input as_update_date_operator")
        tags << active_scaffold_search_date_bridge_calendar_control(column, options, current_params[:value], 'value')
        tags << active_scaffold_update_date_bridge_trend_tag(column, current_params, options)
        tags.join("&nbsp;").html_safe
      end

      def active_scaffold_update_date_bridge_trend_tag(column, current_params, options)
        active_scaffold_date_bridge_trend_tag(column, options,
                                             {:name_prefix => '[record]',
                                              :number_value => current_params[:number],
                                              :unit_value => current_params[:unit],
                                              :show => ['PLUS','MINUS'].include?(current_params[:operator])})
      end
    end
  end
end
