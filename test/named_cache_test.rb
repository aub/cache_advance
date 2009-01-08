require File.dirname(__FILE__) + '/test_helper.rb'

class NamedCacheTest < Test::Unit::TestCase
  
  def setup
    @request = mock
  end
  
  def test_key_for_in_basic_case
    create_named_cache
    assert_equal 'test_cache', @named_cache.key_for(@request)
    assert_equal 'test_cachesuf', @named_cache.key_for(@request, 'suf')
  end
  
  def test_key_with_qualifiers
    
  end
  
  protected
  
  def create_named_cache(options={})
    @name = options[:name] || 'test_cache'
    @params = {}
    @cache_set = CacheAdvance::CacheSet.new
    @cache = CacheAdvance::CacheMock.new
    @named_cache = CacheAdvance::NamedCache.new(@name, @params, @cache_set, @cache)
  end
end


# module CacheAdvance  
#   class NamedCache
#     STORED_KEY = 'STORED_CACHES'
#     
#     def initialize(name, params, configuration, cache)
#       @name = name.to_s
#       @params = params
#       @configuration = configuration
#       @cache = cache
#     end
#     
#     def key_for(request, suffix='')
#       key = @name.dup
#       key << suffix.to_s
#               
#       qualifiers.each do |q|
#         if (qualifier = @configuration.qualifiers[q])
#           this_one = qualifier.call(request)
#           key << this_one.to_s unless this_one.nil?
#         end
#       end if qualifiers
#       key
#     end
#     
#     def value_for(request, options, &block)
#       key = key_for(request, options[:key])
# 
#       if (cache = @cache.read(key))
#         call_plugins('after_read', key, request)
#         return cache
#       end
#       
#       call_plugins('before_write', key, request)
#       result = block.call
#       @cache.write(key, result, rails_options)      
#       call_plugins('after_write', key, request)
#       
#       add_to_cached_keys_list(key)
#       
#       result
#     end
#     
#     def rails_options
#       options = {}
#       options[:expires_in] = expiration_time if expiration_time
#       options
#     end
#     
#     def expire_for(type)
#       if expiration_types.include?(type)
#         expire_all
#       end
#     end
#     
#     def expire_all
#       if (data = @cache.read(@name + STORED_KEY))
#         data = Array(Marshal.load(data))
#         data.each { |key| @cache.delete(key) }
#       else
#         @cache.delete(@name)
#       end
#     end
#     
#     def expiration_types
#       Array(@params[:expiration_types])
#     end
#     
#     def expiration_time
#       @params[:expiration_time]
#     end
#     
#     def qualifiers
#       Array(@params[:qualifiers])
#     end
#     
#     protected
#         
#     def call_plugins(method, key, request)
#       @configuration.plugins.each { |p| p.send(method, @name, key, request) if p.respond_to?(method) }
#     end
#     
#     def add_to_cached_keys_list(key)
#       unless expiration_types.blank? || key == @name
#         if (data = @cache.read(@name + STORED_KEY))
#           data = Array(Marshal.load(data))
#         else
#           data = []
#         end
#         unless data.include?(key)
#           @cache.write(@name + STORED_KEY, Marshal.dump(data << key))
#         end
#       end
#     end
#   end
# end

