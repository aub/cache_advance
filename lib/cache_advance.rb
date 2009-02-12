require 'cache_advance/cache_set'
require 'cache_advance/cached_key_list'
require 'cache_advance/mapper'
require 'cache_advance/named_cache'
require 'cache_advance/named_cache_configuration'

module CacheAdvance
  class UnknownNamedCacheException < Exception; end

  class << self
    attr_reader :cache_set
  end

  def self.define_caches(store)
    @cache_set = CacheSet.new(store)
    yield Mapper.new(@cache_set)
    @cache_set.setup_complete # This allows the cache set to finalize some of its configuration
  end
end
