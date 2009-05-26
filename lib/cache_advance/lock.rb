module CacheAdvance
  class Lock

    class LockAcquisitionFailureException < Exception; end
    
    DEFAULT_RETRIES = 5
    DEFAULT_EXPIRATION_TIME = 30

    def initialize(store)
      @store = store
    end
    
    def execute_locked(key, lock_expiry = DEFAULT_EXPIRATION_TIME, retries = DEFAULT_RETRIES)
      begin
        acquire(key, lock_expiry, retries)
        yield
      ensure
        release_lock(key)
      end
    end
    
    def acquire(key, lock_expiry = DEFAULT_EXPIRATION_TIME, retries = DEFAULT_RETRIES)
      retries.times do |count|
        begin
          return if @store.set("lock/#{key}", Process.pid, lock_expiry) == "STORED\r\n"
        end
        exponential_sleep(count) unless count == retries - 1
      end
      raise LockAcquisitionFailureException, "Couldn't acquire memcache lock for: #{key}"
    end

    def release_lock(key)
      @store.delete("lock/#{key}")
    end

    def exponential_sleep(count)
      sleep((2**count) / 10.0)
    end
  end
end
