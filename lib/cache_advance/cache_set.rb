module CacheAdvance    
  class CacheSet
    attr_reader :named_caches
    attr_reader :qualifiers
    attr_reader :plugins
    
    def initialize
      @named_caches = {}
      @qualifiers = {}
      @plugins = []
    end
    
    def apply(cache_name, request, options, &block)
      named_cache = @named_caches[cache_name]
      raise UnknownNamedCacheException if named_cache.nil?
      named_cache.value_for(request, options, &block)
    end
    
    def add_qualifier(name, proc)
      @qualifiers[name] = proc
    end
    
    def add_plugin(plugin)
      @plugins << plugin
    end
    
    def add_named_cache(name, options)
      @named_caches[name] = NamedCache.new(name, options, self, @cache)
    end
    
    def define_caches
      yield Mapper.new(self)
    end
    
    def create_sweepers
      @sweeper_type.initialize_observed(@named_caches.values.map { |c| c.expiration_types }.flatten.compact.uniq)
    end
    
    def expire_for_class(class_name)
      @named_caches.values.each do |named_cache|
        named_cache.expire_for(class_name)
      end
    end
    
    def cache_type=(type)
      @cache = type.new
    end
    
    def sweeper_type=(type)
      @sweeper_type = type
    end
  end
end
