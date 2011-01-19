module CacheAdvance
  class NamedCache

    def initialize(name, params, cache_set, store)
      @name = name.to_s
      @params = params
      @cache_set = cache_set
      @store = store
    end
        
    def value_for(request, options, &block)
      key = key_for(request, options[:key])
      
      if (value = read_from_store(key))
        each_plugin { |p| p.send('after_read', @name, key, value, options) if p.respond_to?('after_read') }
        return value
      end
      
      each_plugin { |p| p.send('before_render', @name, key, options) if p.respond_to?('before_render') }
      result = block.call
      each_plugin { |p| p.send('after_render', @name, key, result, options) if p.respond_to?('after_render') }
      each_plugin { |p| p.send('before_write', @name, key, result, options) if p.respond_to?('before_write') }
      write_to_store(key, result)
      each_plugin { |p| p.send('after_write', @name, key, result, options) if p.respond_to?('after_write') }      
      result
    end
        
    protected
        
    def read_from_store(key)
      begin
        @store.get(key)
      rescue MemCache::MemCacheError, Errno::ECONNREFUSED => exception
        log_memcache_error(exception)
        nil
      end
    end
    
    def write_to_store(key, value)
      begin
        expiration_time ? @store.set(key, value, expiration_time) : @store.set(key, value)
      rescue MemCache::MemCacheError, Errno::ECONNREFUSED => exception
        log_memcache_error(exception)
        nil
      end
    end

    def each_plugin
      @cache_set.plugins.each do |p|
        yield p
      end
    end
    
    def key_for(request, suffix='')
      qualifier_data = qualifiers.map do |q|
        if (qualifier = @cache_set.qualifiers[q])
          (qualifier.call(request) || '').to_s
        end
      end.join('/')
      "#{@name}/#{suffix}/[#{qualifier_data}]".gsub(/\s/, '')
    end
        
    def expiration_time
      @params[:expiration_time]
    end
    
    def qualifiers
      Array(@params[:qualifiers])
    end

    def log_memcache_error(exception)
      if defined?(Rails) && Rails.respond_to?(:logger)
        Rails.logger.error(exception.message)
      end
    end
  end
end
