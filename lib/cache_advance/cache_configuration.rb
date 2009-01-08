module Patch
  module CacheAdvance
    class CacheConfiguration
      attr_reader :caches
      attr_accessor :qualifiers
      attr_accessor :plugins
      
      class << self
        attr_accessor :observer_type
      end
      
      def initialize
        @caches = {}
        @qualifiers = {}
        @plugins = []
      end
      
      def apply(cache_name, request, options, &block)
        cache = @caches[cache_name]
        cache.value_for(request, options, &block)
      end
      
      def qualifier(name, &proc)
        @qualifiers[name] = proc
      end
      
      def plugin(name)
        if name.is_a?(Symbol)
          @plugins << name.to_s.camelcase.constantize.new
        elsif name.is_a?(Class)
          @plugins << name.new
        else
          @plugins << name
        end
      end
      
      def method_missing(method, options={}, &block)
        @caches[method] = Cache.new(method, options, self)
      end
      
      def create_sweepers
        self.class.observer_type.initialize_observed(@caches.values.map { |c| c.expiration_types }.flatten.compact.uniq)
      end
    end
  end
end