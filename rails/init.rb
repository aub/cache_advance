require 'cache_advance'
require 'cache_advance/active_record_sweeper'
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
  CacheAdvance::Caches.sweeper_type = CacheAdvance::ActiveRecordSweeper
  CacheAdvance::Caches.cache = CacheAdvance::RailsCache.new
  
  CacheAdvance::Caches.create_sweepers
  ActiveRecord::Base.observers << CacheAdvance::ActiveRecordSweeper
  
  ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
    CacheAdvance::ActiveRecordSweeper.instance.reload_sweeper
  end
end
