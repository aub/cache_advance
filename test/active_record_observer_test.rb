require File.dirname(__FILE__) + '/test_helper.rb'

require 'cache_advance/active_record_observer'

class ActiveRecordObserverTest < Test::Unit::TestCase
  
  def setup
    @observer = CacheAdvance::ActiveRecordObserver.instance
  end
  
  def test_should_call_observe_with_a_given_set_of_classes
    CacheAdvance::ActiveRecordObserver.expects(:observe).with([:publications, :articles])
    CacheAdvance::ActiveRecordObserver.initialize_observed([:publications, :articles])
  end
end

# module CacheAdvance
#   class ActiveRecordObserver < ActiveRecord::Observer
# 
#     def self.initialize_observed(classes)
#       observe(classes)
#     end
# 
#     def reload_observer
#       Set.new(observed_classes + observed_subclasses).each do |klass| 
#         klass.name.constantize.add_observer(self)
#       end
#     end
# 
#     def after_create(object)
#       expire_caches_for(object)
#     end
# 
#     alias_method :after_update, :after_create
#     alias_method :after_destroy, :after_create
# 
#     protected
#     
#     def expire_caches_for(object)
#       class_symbol = object.class.name.underscore.to_sym
#       CacheAdvance::Caches.expire_for_class(class_symbol)
#     end
#   end
# end
