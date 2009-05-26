require File.join(File.dirname(__FILE__), 'test_helper.rb')

require 'cache_advance/active_record_sweeper'

class Article; end
class Publication; end

class ActiveRecordSweeperTest < Test::Unit::TestCase
  
  def setup
    @sweeper = CacheAdvance::ActiveRecordSweeper.instance
  end
  
  def test_should_call_observe_with_a_given_set_of_classes
    CacheAdvance::ActiveRecordSweeper.expects(:observe).with([:publication, :article])
    CacheAdvance::ActiveRecordSweeper.initialize_observed([:publication, :article])
  end
  
  def test_should_re_add_observers
    CacheAdvance::ActiveRecordSweeper.initialize_observed([:publication, :article])
    Article.expects(:add_observer).with(@sweeper)
    Publication.expects(:add_observer).with(@sweeper)
    @sweeper.reload_sweeper
  end
  
  def test_should_expire_caches_on_changes
    CacheAdvance.cache_set.expects(:expire_for_class).with(:publication).times(3)
    %w(after_create after_update after_destroy).each do |method|
      @sweeper.send(method, Publication.new)
    end
  end
end
