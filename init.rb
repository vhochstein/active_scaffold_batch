ACTIVE_SCAFFOLD_BATCH_PLUGIN = true

require 'active_scaffold_batch'

begin
  ActiveScaffoldAssets.copy_to_public(ActiveScaffoldBatch.root)
rescue
  raise $! unless Rails.env == 'production'
end