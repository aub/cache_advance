module CacheAdvance
  class RailsCache
    def read(key)
      Rails.cache.read(key)
    end
    
    def write(key, value, options={})
      Rails.cache.write(key, value, options)
    end
    
    def delete(key)
      Rails.cache.delete(key)
    end
  end
end
