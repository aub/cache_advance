module CacheAdvance    
  class CacheSet
    attr_reader :named_caches
    attr_reader :qualifiers
    attr_reader :plugins
    attr_accessor :observer_type
    attr_accessor :cache
    
    def initialize
      @named_caches = {}
      @qualifiers = {}
      @plugins = []
    end
    
    def apply(cache_name, request, options, &block)
      cache = @named_caches[cache_name]
      raise UnknownNamedCacheException if cache.nil?
      cache.value_for(request, options, &block)
    end
    
    def add_qualifier(name, proc)
      @qualifiers[name] = proc
    end
    
    def add_plugin(plugin)
      @plugins << plugin
    end
    
    def add_named_cache(name, options)
      @named_caches[name] = NamedCache.new(name, options, self, cache)
    end
    
    def define_caches
      yield Mapper.new(self)
    end
    
    def create_sweepers
      observer_type.initialize_observed(@named_caches.values.map { |c| c.expiration_types }.flatten.compact.uniq)
    end
    
    def expire_for_class(class_name)
      @named_caches.values.each do |cache|
        cache.expire_for(class_name)
      end
    end
  end
end
