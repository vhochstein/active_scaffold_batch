ACTIVE_SCAFFOLD_BATCH_INSTALLED = :plugin

require 'active_scaffold_batch'

begin
  ActiveScaffoldAssets.copy_to_public(ActiveScaffoldBatch.root)
rescue
  raise $! unless Rails.env == 'production'
end