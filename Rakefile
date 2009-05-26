require 'rubygems'
require 'rake'
require 'rake/testtask'

FileList['tasks/**/*.rake'].each { |file| load file }

task :default => 'test'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'cache_advance'
    gemspec.summary = 'A declarative system for caching with ActiveRecord'
    gemspec.email = 'aubreyholland@gmail.com'
    gemspec.homepage = 'http://github.com/aub/cache_advance/tree/master'
    gemspec.description = 'hmm'
    gemspec.authors = ['Aubrey Holland']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

