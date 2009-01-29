module CacheAdvance  
  class NamedCache
    STORED_KEY = 'STORED_CACHES'
    
    def initialize(name, params, cache_set, cache)
      @name = name.to_s
      @params = params
      @cache_set = cache_set
      @cache = cache
    end
    
    def key_for(request, suffix='')
      key = @name.dup
      key << suffix.to_s
              
      key << qualifiers.map do |q|
        if (qualifier = @cache_set.qualifiers[q])
          (qualifier.call(request) || '').to_s
        end
      end.join('')
      key
    end
    
    def value_for(request, options, &block)
      key = key_for(request, options[:key])
      
      if (cache = @cache.read(key))
        each_plugin { |p| p.send('after_read', @name, key, request, cache) if p.respond_to?('after_read') }
        return cache
      end
      
      each_plugin { |p| p.send('before_render', @name, key, request) if p.respond_to?('before_render') }
      result = block.call
      each_plugin { |p| p.send('after_render', @name, key, request, result) if p.respond_to?('after_render') }
      each_plugin { |p| p.send('before_write', @name, key, request, result) if p.respond_to?('before_write') }
      @cache.write(key, result, rails_options)
      each_plugin { |p| p.send('after_write', @name, key, request, result) if p.respond_to?('after_write') }
      
      add_to_cached_keys_list(key)
      
      result
    end
    
    def rails_options
      options = {}
      options[:expires_in] = expiration_time if expiration_time
      options
    end
    
    def expire_for(type)
      if expiration_types.include?(type)
        expire_all
      end
    end
    
    def expire_all
      if (data = @cache.read(@name + STORED_KEY))
        data = Array(Marshal.load(data))
        data.each { |key| @cache.delete(key) }
      else
        @cache.delete(@name)
      end
    end
    
    def expiration_types
      Array(@params[:expiration_types])
    end
    
    def expiration_time
      @params[:expiration_time]
    end
    
    def qualifiers
      Array(@params[:qualifiers])
    end
    
    protected
        
    def each_plugin
      @cache_set.plugins.each do |p|
        yield p
      end
    end
    
    def add_to_cached_keys_list(key)
      unless expiration_types.blank? || key == @name
        if (data = @cache.read(@name + STORED_KEY))
          data = Array(Marshal.load(data))
        else
          data = []
        end
        unless data.include?(key)
          @cache.write(@name + STORED_KEY, Marshal.dump(data << key))
        end
      end
    end
  end
end
