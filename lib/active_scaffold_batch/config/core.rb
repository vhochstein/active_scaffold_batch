# Need to open the AS module carefully due to Rails 2.3 lazy loading
ActiveScaffold::Config::Core.class_eval do
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_edit] = :get
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_update] = :post
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_new] = :get
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_create] = :post
  #not working because routing picks show route instead
  #ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_destroy] = :get
  #you may define a route for your controller before resource routes
  #match 'players/batch_destroy' => 'players#batch_destroy', :via => [:get]
  ActionDispatch::Routing::ACTIVE_SCAFFOLD_CORE_ROUTING[:collection][:batch_destroy] = :delete
end