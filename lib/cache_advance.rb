%w( cache_set cached_key_list lock mapper named_cache named_cache_configuration).each do |file|
  require File.join(File.dirname(__FILE__), 'cache_advance', file)
end

module CacheAdvance
  class UnknownNamedCacheException < Exception; end

  class << self
    attr_reader :cache_set
    attr_accessor :caching_enabled
  end

  @cache_set = nil
  @caching_enabled = true

  def self.define_caches(store)
    @cache_set = CacheSet.new(store)
    yield Mapper.new(@cache_set)
    @cache_set.setup_complete # This allows the cache set to finalize some of its configuration
  end
end
