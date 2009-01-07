Gem::Specification.new do |s|
  s.version = '1.0.0'
  s.date = %q{2008-11-07}
 
  s.name = %q{cache_advance}
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Aubrey Holland', 'patch']
  s.description = %q{}
  s.email = %q{aubrey@patch.com}
  s.files = %w()
  s.homepage = %q{}
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{}
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile']
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.textile']
  s.test_files = %w(cache_advance_test.rb)
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
