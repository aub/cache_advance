require 'rubygems'
gem 'activerecord'
require 'active_record/observer'

module CacheAdvance
  class ActiveRecordSweeper < ::ActiveRecord::Observer

    def self.initialize_observed(classes)
      observe(classes)
    end

    def reload_sweeper
      observed_classes.each do |klass| 
        klass.name.constantize.add_observer(self)
      end
    end

    def after_create(object)
      expire_caches_for(object)
    end

    alias_method :after_update, :after_create
    alias_method :after_destroy, :after_create

    protected
    
    def expire_caches_for(object)
      class_symbol = object.class.name.underscore.to_sym
      CacheAdvance.cache_set.expire_for_class(class_symbol)
    end
  end
end
