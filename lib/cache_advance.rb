require 'cache_advance/named_cache'
require 'cache_advance/cache_set'
require 'cache_advance/mapper'

module CacheAdvance
  class UnknownNamedCacheException < Exception; end
  
  Caches = CacheSet.new
end
