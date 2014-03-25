# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'guard/rake/version'

Gem::Specification.new do |s|
  s.name        = 'guard-rake-vagrant'
  s.version     = Guard::Rake::Vagrant::VERSION
  s.authors     = ['Salim Afiune']
  s.email       = ['salim@afiunemaya.com.mx']
  s.homepage    = 'https://github.com/afiune/guard-rake-vagrant'
  s.summary     = %q{Guard Plugin that uses Rake and Vagrant to converge cookbooks and run integration tests}
  s.description = %q{guard-rake-vagrant runs rake tasks from Rakefile automatically but first provisioning a box using Vagrant}

  s.add_dependency 'guard'
  s.add_dependency 'rake'
  s.add_dependency 'mixlib-shellout'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  s.require_paths = ['lib']
end

