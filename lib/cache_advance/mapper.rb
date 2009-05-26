gem 'activesupport'
require 'active_support/core_ext'

module CacheAdvance
  class Mapper
    def initialize(cache_set)
      @cache_set = cache_set
    end
    
    def qualifier(name, &proc)
      @cache_set.add_qualifier(name, proc)
    end
    
    def plugin(name)
      if name.is_a?(Symbol)
        plugin = name.to_s.camelcase.constantize.new
      elsif name.is_a?(Class)
        plugin = name.new
      else
        plugin = name
      end
      @cache_set.add_plugin(plugin)
    end
    
    def method_missing(method, options={})
      @cache_set.add_named_cache(method, options)
    end
  end
end
