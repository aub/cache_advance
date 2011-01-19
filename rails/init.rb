require 'cache_advance'

require "#{RAILS_ROOT}/config/caches"
require 'dispatcher'

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
