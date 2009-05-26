require File.join(File.dirname(__FILE__), 'test_helper')

class KeyTest < Test::Unit::TestCase

  def setup
    @cache = CacheAdvance::CacheMock.new
    @cache_set = CacheAdvance::CacheSet.new(@cache)
  end

  def test_should_symbolize_the_cache_name
    @cache_set.add_named_cache('booya', {})
    assert_nothing_raised do
      @cache_set.apply(:booya, nil, :key => 'abc') do
        '123'
      end
    end
  end

  def test_should_symbolize_the_cache_name_when_using_it 
    @cache_set.add_named_cache(:booya, {})
    assert_nothing_raised do
      @cache_set.apply('booya', nil, :key => 'abc') do
        '123'
      end
    end
  end

  def test_should_remove_whitespace_from_the_key
    @cache_set.add_named_cache(:booya, {})
    result = @cache_set.apply(:booya, nil, :key => 'abc def') do
      '123'
    end
    assert_equal '123', @cache.get('booya/abcdef/[]')
    assert_equal '123', result
    @cache.set('booya/abcdef/[]', '234')
    result = @cache_set.apply(:booya, nil, :key => 'abc def') do
      '123'
    end
    assert_equal '234', result
  end
end
