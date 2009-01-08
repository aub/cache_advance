require File.dirname(__FILE__) + '/test_helper.rb'

class Plugin; end

require 'cache_advance/active_record_observer'

class CacheSetTest < Test::Unit::TestCase
  def setup
    @cache_set = CacheAdvance::CacheSet.new
  end
  
  def test_define_caches_should_yield_a_mapper
    @cache_set.define_caches do |mapper|
      assert_equal CacheAdvance::Mapper, mapper.class
    end
  end
  
  def test_should_apply_the_cache_if_found
    request = mock
    options = { :key => 'hippo' }
    @cache_set.add_named_cache(:kewl, {})
    @cache_set.named_caches[:kewl].expects(:value_for).with(request, options)
    @cache_set.apply(:kewl, request, options) { }
  end
  
  def test_apply_should_throw_exception_with_invalid_name
    assert_raise CacheAdvance::UnknownNamedCacheException do
      @cache_set.apply(:total_hack, mock(), {}) { }
    end
  end
  
  def test_should_pass_expiration_types_to_the_sweeper
    @cache_set.observer_type = CacheAdvance::ActiveRecordObserver
    @cache_set.add_named_cache(:kewl, { :expiration_types => [:publication, :article] })
    @cache_set.add_named_cache(:howza, { :expiration_types => [:publication] })
    CacheAdvance::ActiveRecordObserver.expects(:initialize_observed).with([:publication, :article])
    @cache_set.create_sweepers
  end
end
