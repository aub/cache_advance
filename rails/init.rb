require 'cache_advance'
require 'cache_advance/active_record_observer'
require 'cache_advance/rails_cache'
require 'config/caches'
require 'dispatcher'

ActionController::Base.helper do  
  def cache_it(cache, options={}, &block)
    CacheAdvance::Caches.apply(cache, request, options) do
      capture(&block)
    end
  end
end

config.after_initialize do
  CacheAdvance::Caches.observer_type = CacheAdvance::ActiveRecordObserver
  CacheAdvance::Caches.cache = CacheAdvance::RailsCache.new
  
  CacheAdvance::Caches.create_sweepers
  ActiveRecord::Base.observers << CacheAdvance::ActiveRecordObserver
  
  ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
    CacheAdvance::ActiveRecordSweeper.instance.reload_sweeper
  end
end
