require 'cache_advance'
require 'cache_advance/active_record_sweeper'

require "#{RAILS_ROOT}/config/caches"
require 'dispatcher'

# Setup the sweeper and cache types as appropriate for Rails.
CacheAdvance.cache_set.sweeper_type = CacheAdvance::ActiveRecordSweeper

CacheAdvance.caching_enabled = config.action_controller.perform_caching

# This is the helper method that can be used in rails views/controllers/helpers.
# If caching is disabled, just make it yield the results of the block.
if config.action_controller.perform_caching
  ActionController::Base.helper do
    def cache_it(cache, options={}, &block)
      CacheAdvance.cache_set.plugins.each do |plugin|
        options.merge!(plugin.cache_it_options(self)) if plugin.respond_to?('cache_it_options')
      end
      CacheAdvance.cache_set.apply(cache, request, options) do
        capture(&block)
      end
    end
  end
else
  ActionController::Base.helper do
    def cache_it(cache, options={}, &block)
      capture(&block)
    end
  end
end
 
ActionMailer::Base.helper do
  def cache_it(cache, options={}, &block)
    capture(&block)
  end
end

# This will get called after the standard rails environment is initialized.
config.after_initialize do
  if config.action_controller.perform_caching
    # This hooks the sweepers into the observer system and adds it to the list.
    CacheAdvance.cache_set.create_sweepers
    ActiveRecord::Base.observers << CacheAdvance::ActiveRecordSweeper

    # In development mode, the models we observe get reloaded with each request. Using
    # this hook allows us to reload the observer relationships each time as well.
    ActionController::Dispatcher.to_prepare(:cache_advance_reload) do
      CacheAdvance::ActiveRecordSweeper.instance.reload_sweeper
    end
  end
end
