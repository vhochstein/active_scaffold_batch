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
          send(override_update(column.update_ui), column, options)
        else
          active_scaffold_input_for(column, scope, options)
        end
      end

      def active_scaffold_update_numeric(column, options)
        select_options = ActiveScaffold::Finder::NumericOperators.collect {|comp| [as_(comp.downcase.to_sym), comp]}
        html = select_tag("#{column.name}[opt]",
              options_for_select(select_options, opt_value),
              :id => "#{options[:id]}_opt",
              :class => "as_update_numeric_option")
        html << ' ' << text_field_tag("#{column.name}[value]", nil, options)
        html
      end
      alias_method :active_scaffold_update_integer, :active_scaffold_update_numeric
      alias_method :active_scaffold_update_decimal, :active_scaffold_update_numeric
      alias_method :active_scaffold_update_float, :active_scaffold_update_numeric

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
