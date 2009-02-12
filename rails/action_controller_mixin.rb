module CacheAdvance
  module ActionControllerMixin
    def self.included(base)
      base.send(:helper_method, :cache_it)
    end
    
    def cache_it(cache_name, options={}, &block)
      CacheAdvance.cache_set.apply(cache, request, options) do
        capture(&block)
      end
    end
  end
end