module Patch
  module CacheAdvance
    class Definitions
      class << self
        attr_reader :cache_configuration
      end
      
      def self.define_caches(&block)
        yield(@cache_configuration = CacheConfiguration.new)
      end
    end
  end
end
