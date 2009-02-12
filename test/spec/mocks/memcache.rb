class MemCache
  attr_reader :data
  
  def initialize
    @data = {}
  end
  
  def decr(key, amount = 1)
  end

  def get(key, raw = false)
    return @data[key]
  end

  def get_multi(*keys)
  end

  def incr(key, amount = 1)
  end

  def set(key, value, expiry = 0, raw = false)
    @data[key] = value
  end

  def add(key, value, expiry = 0, raw = false)
  end

  def delete(key, expiry = 0)
    @data.delete(key)
  end

  def flush_all
  end

  def reset
    @data = {}
  end

  def stats
  end
end