# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'activeuuid/version'

Gem::Specification.new do |s|
  s.name        = 'activeuuid'
  s.version     = ActiveUUID::VERSION
  s.authors     = ['Nate Murray']
  s.email       = ['nate@natemurray.com']
  s.homepage    = 'https://github.com/jashmenn/activeuuid'
  s.summary     = %q{Add binary UUIDs to ActiveRecord in MySQL}
  s.description = %q{Add binary (not string) UUIDs to ActiveRecord in MySQL}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.99.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'forgery'
  s.add_development_dependency 'fabrication'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql2'

  s.add_runtime_dependency 'uuidtools', '>= 2.1.5'
  s.add_runtime_dependency 'activerecord', '>= 4.2'
end
