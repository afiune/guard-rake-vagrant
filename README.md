guard-rake-vagrant
==================

Guard Plugin that uses Rake and Vagrant to converge cookbooks and run integration tests.

Software & Tools
------------

This gem depends on the well installation of the following software & tools:
* Vagrant - Recomended version 1.2.2 - http://downloads.vagrantup.com/tags/v1.2.2
* Vagrant Plugins
  * vagrant-berkshelf (1.3.7)
  * vagrant-windows (1.5.1)
```
    # vagrant plugin install vagrant-berkshelf
    # vagrant plugin install vagrant-windows
```

Installation
------------

Add this line to your application's Gemfile:

    gem 'guard-rake-vagrant'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install guard-rake-vagrant

Setup
------------

Create a Guardfile:
```
  guard :rake, :task => 'doit' do
    watch(%r{^test/.+_spec\.rb$})
  end
```

Create a Rakefile:
```
require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:doit) do |t|
  # actions (may reference t)
end

desc "This is the description of my :doit task "
```

And then execute:

    $ bundle exec guard


Authors 
------------
Created and maintained by [Salim Afiune](https://github.com/afiune) (salim@afiunemaya.com.mx) and the community.

