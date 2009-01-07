require 'ruby-debug'

module Patch
  module CacheAdvance
    class ActiveRecordObserver < ActiveRecord::Observer

      def self.initialize_observed(classes)
        observe(classes)
      end

      def reload_observer
        Set.new(observed_classes + observed_subclasses).each do |klass| 
          klass.name.constantize.add_observer(self)
        end
      end

      def after_create(object)
        expire_caches_for(object)
      end

      def after_update(object)
        expire_caches_for(object)
      end

      def after_destroy(object)
        expire_caches_for(object)
      end
      
      protected
      
      def expire_caches_for(object)
        class_symbol = object.class.name.underscore.to_sym
        Patch::CacheAdvance::Definitions.cache_configuration.caches.each do |cache|
          cache.expire_for(class_symbol)
        end
      end
    end
  end
end