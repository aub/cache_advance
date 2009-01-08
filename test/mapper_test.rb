require File.dirname(__FILE__) + '/test_helper.rb'

class Hack
end

class MapperTest < Test::Unit::TestCase
  
  def setup
    @cache_set = CacheAdvance::CacheSet.new
    @mapper = CacheAdvance::Mapper.new(@cache_set)
  end
  
  def test_qualifier
    @mapper.qualifier(:thirty_four) do
      34
    end
    assert_equal 1, @cache_set.qualifiers.size
    assert_equal 34, @cache_set.qualifiers[:thirty_four].call
  end
  
  def test_plugin_from_symbol
    @mapper.plugin(:hack)
    assert_equal 1, @cache_set.plugins.size
    assert_equal Hack, @cache_set.plugins.first.class
  end
  
  def test_plugin_from_class
    @mapper.plugin(Hack)
    assert_equal 1, @cache_set.plugins.size
    assert_equal Hack, @cache_set.plugins.first.class
  end
  
  def test_plugin_from_object
    hack = Hack.new
    @mapper.plugin(hack)
    assert_equal 1, @cache_set.plugins.size
    assert_equal hack, @cache_set.plugins.first
  end
  
  def test_adding_caches_through_method_missing
    @mapper.say_what :option => 2
    assert_equal 1, @cache_set.named_caches.size
    assert_equal CacheAdvance::NamedCache, @cache_set.named_caches[:say_what].class
  end
end
