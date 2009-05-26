module CacheAdvance
  class CacheMock
    def initialize
      @values = {}
    end

    def get(key)
      @values[key]
    end
    
    def set(key, value, options={})
      result = @values.has_key?(key) ? @values[key] : "STORED\r\n"
      @values[key] = value
      result
    end
    
    def delete(key)
      @values[key] = nil
    end
  end
end
