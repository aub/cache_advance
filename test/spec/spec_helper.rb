$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'ruby-debug'

gem 'sqlite3-ruby'
require 'spec'
require 'cache_advance'

require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => ':memory:'
)

require File.join(File.dirname(__FILE__), 'db', 'schema')
require File.join(File.dirname(__FILE__), 'mocks', 'memcache')

Spec::Runner.configure do |config|
  # config.mock_with :rr
  config.before :each do
    @memcache = MemCache.new

    CacheAdvance.define_caches(@memcache) do |cache_config|
      cache_config.publication
    end
  end
end
