require File.dirname(__FILE__) + '/test_helper.rb'

class NamedCacheTest < Test::Unit::TestCase
  
  def setup
    @request = mock
  end
  
  def test_key_for_in_basic_case
    create_named_cache
    assert_equal 'test_cache//[]', @named_cache.send(:key_for, @request)
    assert_equal 'test_cache/suf/[]', @named_cache.send(:key_for, @request, 'suf')
  end
  
  def test_key_with_qualifiers
    
  end
  
  protected
  
  def create_named_cache(options={})
    @name = options[:name] || 'test_cache'
    @params = {}
    @cache = CacheAdvance::CacheMock.new
    @cache_set = CacheAdvance::CacheSet.new(@cache)
    @named_cache = CacheAdvance::NamedCache.new(@name, @params, @cache_set, @cache)
  end
end

