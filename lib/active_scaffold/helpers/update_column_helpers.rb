module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module UpdateColumnHelpers
      # This method decides which input to use for the given column.
      # It does not do any rendering. It only decides which method is responsible for rendering.
      def active_scaffold_update_for(column, scope = nil, options = {})
        options = active_scaffold_input_options(column, scope, options)

        # first, check if the dev has created an override for this specific field for search
        if override_update_field?(column)
          send(override_update_field(column), @record, options)
        # second, check if the dev has specified a valid form_ui for this column, using specific ui for searches
        elsif column.form_ui and override_update?(column.form_ui)
          send(override_update(column.form_ui), column, options)
       elsif column.column && column.form_ui.nil? && override_update?(column.column.type)
          send(override_update(column.column.type), column, options)
        else
          active_scaffold_update_generic_operators_select(column, options)<< ' ' << active_scaffold_render_input(column, options.merge(:name => "record[#{column.name}][value]"))
        end
      end

      def active_scaffold_update_generic_operators(column)
        operators = ActiveScaffold::Actions::BatchUpdate::GenericOperators.collect {|comp| [as_(comp.downcase.to_sym), comp]}
        if column.column.nil? || column.column.null
          operators << [as_(:null), 'NULL']
        end
        operators
      end

      def active_scaffold_update_generic_operators_select(column, options)
        current = {:operator => 'NO_UPDATE'}
        current.merge!(batch_update_values[column.name][:value].symbolize_keys) if batch_update_values[column.name] && batch_update_values[column.name][:value]
        select_tag("[record][#{column.name}][operator]",
              options_for_select(active_scaffold_update_generic_operators(column), current[:operator]),
              :id => "#{options[:id]}_operator",
              :class => "as_batch_update_operator text_input")
      end

      def active_scaffold_update_numeric(column, options)
        current = {:value => nil, :opt => 'ABSOLUTE', :operator => 'NO_UPDATE'}
        current.merge!(batch_update_values[column.name][:value].symbolize_keys) if batch_update_values[column.name] && batch_update_values[column.name][:value]
        operator_options = active_scaffold_update_generic_operators(column) + ActiveScaffold::Actions::BatchUpdate::NumericOperators.collect {|comp| [as_(comp.downcase.to_sym), comp]}
        select_options = ActiveScaffold::Actions::BatchUpdate::NumericOptions.collect {|comp| [as_(comp.downcase.to_sym), comp]}
        html = select_tag("[record][#{column.name}][operator]",
              options_for_select(operator_options, current[:operator]),
              :id => "#{options[:id]}_operator",
              :class => "as_update_numeric_option")
        html << ' ' << text_field_tag("[record][#{column.name}][value]", current[:value], active_scaffold_input_text_options)
        html << ' ' << select_tag("[record][#{column.name}][opt]",
              options_for_select(select_options, current[:opt]),
              :id => "#{options[:id]}_opt",
              :class => "as_update_numeric_option")
        html
      end
      alias_method :active_scaffold_update_integer, :active_scaffold_update_numeric
      alias_method :active_scaffold_update_decimal, :active_scaffold_update_numeric
      alias_method :active_scaffold_update_float, :active_scaffold_update_numeric

      def active_scaffold_update_scope_select(select_options = active_scaffold_update_scope_select_options)
        if select_options.length > 1
          select_tag("batch_scope",
                     options_for_select(select_options, batch_scope || select_options.last[1]),
                     :class => "text_input")
        else
          hidden_field_tag("batch_scope", select_options.first[1]) unless select_options.empty?
        end
      end

      def active_scaffold_update_scope_select_options
        select_options = []
        select_options << [as_(:listed), 'LISTED'] if active_scaffold_config.batch_update.list_mode_enabled
        select_options << [as_(:marked), 'MARKED'] if active_scaffold_config.actions.include?(:mark)
        select_options
      end

      ##
      ## Search column override signatures
      ##

      def override_update_field?(column)
        respond_to?(override_update_field(column))
      end

      # the naming convention for overriding form fields with helpers
      def override_update_field(column)
        "#{column.name}_update_column"
      end

      def override_update?(update_ui)
        respond_to?(override_update(update_ui))
      end

      # the naming convention for overriding search input types with helpers
      def override_update(update_ui)
        "active_scaffold_update_#{update_ui}"
      end
    end
  end
end
