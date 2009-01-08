require 'cache_advance'
require 'cache_advance/active_record_sweeper'
require 'cache_advance/rails_cache'
require 'config/caches'
require 'dispatcher'

# This is the helper method that can be used in rails views/controllers/helpers.
ActionController::Base.helper do  
  def cache_it(cache, options={}, &block)
    CacheAdvance::Caches.apply(cache, request, options) do
      capture(&block)
    end
  end
end

# This will get called after the standard rails environment is initialized.
config.after_initialize do
  
  # Setup the sweeper and cache types as appropriate for Rails.
  CacheAdvance::Caches.sweeper_type = CacheAdvance::ActiveRecordSweeper
  CacheAdvance::Caches.cache_type = CacheAdvance::RailsCache
  
  # This hooks the sweepers into the observer system and adds it to the list. 
  CacheAdvance::Caches.create_sweepers
  ActiveRecord::Base.observers << CacheAdvance::ActiveRecordSweeper
  
  # In development mode, the models we observe get reloaded with each request. Using
  # this hook allows us to reload the observer relationships each time as well.
  ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
    CacheAdvance::ActiveRecordSweeper.instance.reload_sweeper
  end
end
