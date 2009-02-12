module CacheAdvance
  module ActionMailerMixin
    def self.included(base)
      base.send(:helper_method, :cache_it)
    end
    
    def cache_it(cache_name, options={}, &block)
      capture(&block)
    end
  end
end