require 'cache_advance'
require 'cache_advance/active_record_observer'
require 'config/caches'
require 'dispatcher'

ActionController::Base.helper do  
  def cache_it(cache, options={}, &block)
    Patch::CacheAdvance::Definitions.cache_configuration.apply(cache, request, options) do
      capture(&block)
    end
  end
end

config.after_initialize do
  Patch::CacheAdvance::CacheConfiguration.observer_type = Patch::CacheAdvance::ActiveRecordObserver
  
  Patch::CacheAdvance::Definitions.cache_configuration.create_sweepers
  ActiveRecord::Base.observers << Patch::CacheAdvance::ActiveRecordObserver
  
  ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
    Patch::CacheAdvance::ActiveRecordObserver.instance.reload_observer
  end
end
