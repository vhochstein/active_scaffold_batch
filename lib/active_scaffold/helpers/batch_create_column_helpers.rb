module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module BatchCreateColumnHelpers
      # This method decides which input to use for the given column.
      # It does not do any rendering. It only decides which method is responsible for rendering.
      def active_scaffold_batch_create_by_column(column, scope = nil, options = {})
        options = active_scaffold_input_options(column, scope, options)

        if column.form_ui == :record_select
          active_scaffold_record_select(column, options, batch_create_by_records, true)
        else
          active_scaffold_batch_create_singular_association(column, options)
        end

      end

      def active_scaffold_batch_create_singular_association(column, html_options)
        associated_options = batch_create_by_records.collect {|r| r.id}
        select_options = options_for_association(column.association)
        html_options.update(column.options[:html_options] || {})
        options = {}
        options.update(column.options)
        html_options[:name] = "#{html_options[:name]}[]" 
        html_options[:multiple] = true
        select_tag(column.name, options_for_select(select_options.uniq, associated_options), html_options)
      end
    end
  end
end
