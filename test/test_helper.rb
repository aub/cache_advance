$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'test/unit'
require 'rubygems'
require 'ruby-debug'

require 'cache_advance'
require 'mocha'
require 'cache_mock'
