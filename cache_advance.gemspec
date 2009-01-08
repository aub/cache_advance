Gem::Specification.new do |s|
  s.version = '1.0.1'
  s.date = %q{2009-01-08}
 
  s.name = %q{cache_advance}
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Aubrey Holland']
  s.description = %q{A system for spiffy declarative caching}
  s.email = %q{aubrey@patch.com}
  s.files = %w(cache_advance.gemspec lib/cache_advance/active_record_sweeper.rb lib/cache_advance/cache_set.rb lib/cache_advance/mapper.rb lib/cache_advance/named_cache.rb lib/cache_advance/rails_cache.rb lib/cache_advance.rb rails/init.rb Rakefile README.textile test/active_record_sweeper_test.rb test/cache_mock.rb test/cache_set_test.rb test/mapper_test.rb test/named_cache_test.rb test/rails_cache_test.rb test/test_helper.rb TODO.textile)
  s.homepage = %q{http://github.com/aub/cache_advance}
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A system for spiffy declarative caching}
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile']
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.textile']
  s.test_files = %w(test/active_record_sweeper_test.rb test/cache_set_test.rb test/mapper_test.rb test/named_cache_test.rb test/rails_cache_test.rb)
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
