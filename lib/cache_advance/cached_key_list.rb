module CacheAdvance
  class CachedKeyList
    def initialize(store, cache_key, expiration_time=nil)
      @store, @cache_key, @expiration_time = store, cache_key, expiration_time
    end
    
    def all_keys
      key_list.keys
    end
    
    def add_key(key)
      Lock.new(@store).execute_locked(@cache_key) do
        data = key_list
        unless data.has_key?(key)
          data[key] = @expiration_time.nil? ? nil : Time.now + @expiration_time
          @store.set(@cache_key, data)
        end
      end
    end
    
    def delete_key(key)
      Lock.new(@store).execute_locked(@cache_key) do
        data = key_list
        if data.has_key?(key)
          data.delete(key)
          @store.set(@cache_key, data)
        end
      end
    end
    
    def clear
      @store.set(@cache_key, {})
    end
    
    protected
    
    def key_list
      list = @store.get(@cache_key) || {}
      if @expiration_time
        now = Time.now
        list.delete_if { |k,v| v <= now }
      end
      list
    end
  end
end
