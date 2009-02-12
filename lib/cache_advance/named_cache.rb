module CacheAdvance
  class NamedCache

    ENABLED_CHECK_INTERVAL = 60
    
    def initialize(name, params, cache_set, store)
      @name = name.to_s
      @params = params
      @cache_set = cache_set
      @store = store
      @cached_key_list = CachedKeyList.new(@store, "#{@name}/STORED_CACHES", expiration_time)
      @enabled_check_time = Time.now + ENABLED_CHECK_INTERVAL
      @enabled = nil
    end
        
    def value_for(request, options, &block)
      return block.call unless enabled?
      
      key = key_for(request, options[:key])
      
      if (value = read_from_store(key))
        each_plugin { |p| p.send('after_read', @name, key, request, value) if p.respond_to?('after_read') }
        return value
      end
      
      each_plugin { |p| p.send('before_render', @name, key, request) if p.respond_to?('before_render') }
      result = block.call
      each_plugin { |p| p.send('after_render', @name, key, request, result) if p.respond_to?('after_render') }
      each_plugin { |p| p.send('before_write', @name, key, request, result) if p.respond_to?('before_write') }
      write_to_store(key, result)
      each_plugin { |p| p.send('after_write', @name, key, request, result) if p.respond_to?('after_write') }      
      result
    end
        
    def expire_for(type)
      if expiration_types.include?(type)
        expire_all
      end
    end
    
    def expire_all
      delete_all_from_store
    end
        
    def all_cached_keys
      @cached_key_list.all_keys
    end
    
    def expiration_types
      Array(@params[:expiration_types])
    end
    
    def title
      @params[:title] || @name.to_s
    end
    
    def enabled=(state)
      @enabled = !!state
      write_to_store(enabled_key, @enabled, false)
    end
    
    def enabled?
      if @enabled.nil? || Time.now >= @enabled_check_time
        @enabled = [nil, true].include?(read_from_store(enabled_key))
        @enabled_check_time = Time.now + ENABLED_CHECK_INTERVAL
      end
      @enabled
    end
    
    protected
        
    def read_from_store(key)
      @store.get(key)
    end
    
    def write_to_store(key, value, add_to_key_list=true)
      expiration_time ? @store.set(key, value, expiration_time) : @store.set(key, value)
      if add_to_key_list
        @cached_key_list.add_key(key)
      end
    end

    def delete_from_store(key)
      @store.delete(key)
      @cached_key_list.delete_key(key)
    end
        
    def delete_all_from_store
      @cached_key_list.all_keys.each { |key| delete_from_store(key) }
      @cached_key_list.clear
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
      "#{@name}/#{suffix}/[#{qualifier_data}]"
    end
        
    def enabled_key
      "#{@name}/ENABLED_STATUS"
    end  
      
    def expiration_time
      @params[:expiration_time]
    end
    
    def qualifiers
      Array(@params[:qualifiers])
    end
  end
end
