module Patch
  module CacheAdvance
    class Cache
      def initialize(name, params, configuration)
        @name = name.to_s
        @params = params
        @configuration = configuration
      end
      
      def key_for(request, suffix='')
        key = @name.dup
        key << suffix.to_s
        
        @configuration.qualifiers[@name].each do |q| 
          this_one = q.call(request)
          key << this_one.to_s unless this_one.nil?
        end if @configuration.qualifiers[@name]
        key
      end
      
      def value_for(request, options, &block)
        key = key_for(request, options[:key])

        if (cached = Rails.cache.read(key))
          return cached
        end

        result = block.call
        
        Rails.cache.write(key, result, rails_options)
        
        if key != @name
          # I can write to memcached the list of things that are in it for a given cache.
          # Then, if the cache depends on the params, I can read the caches it has and invalidate
          # them if a cache invalidates based on changes to objects
        end
        result
      end
      
      def rails_options
        options = {}
        options[:expires_in] = @params[:expiration_time] if @params[:expiration_time]
        options
      end
      
      def expire_for(type)
        if @params[:expiration_types].find(type)
          expire_all
        end
      end
      
      def expire_all
        Rails.cache.delete(@name)
      end
      
      def expiration_types
        @params[:expiration_types]
      end
    end
  end
end
