# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cache_advance}
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aubrey Holland"]
  s.date = %q{2009-05-26}
  s.description = %q{hmm}
  s.email = %q{aubreyholland@gmail.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "README.textile",
     "Rakefile",
     "TODO.textile",
     "VERSION",
     "lib/cache_advance.rb",
     "lib/cache_advance/active_record_sweeper.rb",
     "lib/cache_advance/cache_set.rb",
     "lib/cache_advance/cached_key_list.rb",
     "lib/cache_advance/lock.rb",
     "lib/cache_advance/mapper.rb",
     "lib/cache_advance/named_cache.rb",
     "lib/cache_advance/named_cache_configuration.rb",
     "rails/init.rb",
     "test/active_record_sweeper_test.rb",
     "test/cache_mock.rb",
     "test/cache_set_test.rb",
     "test/key_test.rb",
     "test/mapper_test.rb",
     "test/named_cache_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/aub/cache_advance/tree/master}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A declarative system for caching with ActiveRecord}
  s.test_files = [
    "test/active_record_sweeper_test.rb",
     "test/cache_mock.rb",
     "test/cache_set_test.rb",
     "test/key_test.rb",
     "test/mapper_test.rb",
     "test/named_cache_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
