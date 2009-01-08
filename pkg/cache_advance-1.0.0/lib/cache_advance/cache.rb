module Patch
  module CacheAdvance
    class Cache
      STORED_KEY = 'STORED_CACHES'
      
      def initialize(name, params, configuration)
        @name = name.to_s
        @params = params
        @configuration = configuration
      end
      
      def key_for(request, suffix='')
        key = @name.dup
        key << suffix.to_s
                
        @params[:qualifiers].each do |q|
          if (qualifier = @configuration.qualifiers[q])
            this_one = qualifier.call(request)
            key << this_one.to_s unless this_one.nil?
          end
        end if @params[:qualifiers]
        key
      end
      
      def value_for(request, options, &block)
        key = key_for(request, options[:key])

        if (cache = Rails.cache.read(key))
          call_plugins('after_read', key, request)
          return cache
        end
        
        call_plugins('before_write', key, request)
        
        result = block.call
        
        Rails.cache.write(key, result, rails_options)
        
        call_plugins('after_write', key, request)
        
        if key != @name # AND IT EXPIRES BY TYPE!!!!!!
          # stored = Rails.cache.read
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
      
      protected
      
      def call_plugins(method, key, request)
        @configuration.plugins.each { |p| p.send(method, @name, key, request) if p.respond_to?(method) }
      end
    end
  end
end
