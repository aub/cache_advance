module CacheAdvance    
  class CacheSet
    attr_reader :named_caches
    attr_reader :qualifiers
    attr_reader :plugins
    
    def initialize(store)
      @store, @named_caches, @qualifiers, @plugins = store, {}, {}, []
    end
    
    def setup_complete
    end
    
    def apply(cache_name, request, options, &block)
      cache_name = cache_name.to_sym
      if CacheAdvance.caching_enabled
        named_cache = @named_caches[cache_name]
        raise UnknownNamedCacheException if named_cache.nil?
        named_cache.value_for(request, options, &block)
      else
        block.call
      end
    end
    
    def add_qualifier(name, proc)
      @qualifiers[name] = proc
    end
    
    def add_plugin(plugin)
      @plugins << plugin
    end
    
    def add_named_cache(name, options)
      name = name.to_sym
      @named_caches[name] = NamedCache.new(name, options, self, @store)
    end
    
    def define_caches
      yield Mapper.new(self)
    end
  end
end
