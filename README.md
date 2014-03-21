guard-rake-vagrant
==================

Guard Plugin that uses Rake and Vagrant to converge Chef Cookbooks and run integration tests.

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

Add this line to your Cookbook Gemfile:

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

Create a Vagrantfile:
```
box           = "Windows2008R2"
box_url       = "Windows2008R2.box"
cookbook_name = "my_cookbook_name"

Vagrant.configure("2") do |config|
  config.vm.define cookbook_name do |config|
    config.vm.box               = box
    config.vm.box_url           = box_url
    
    # Windows Plugin if platform?("windows")
    config.vm.guest             = :windows
    
    # FW ports if platform?("windows")
    config.vm.network :forwarded_port, { :guest=>3389, :host=>3389, :id=>"rdp", :auto_correct=>true }
    config.vm.network :forwarded_port, { :guest=>5985, :host=>5985, :id=>"winrm", :auto_correct=>true }

    # Berkshelf Plugin
    config.berkshelf.enabled    = true

    config.vm.provider :virtualbox do |p|
        p.customize ["modifyvm", :id, "--memory", "512"]
    end

    config.vm.provision :chef_solo do |chef|
      chef.log_level = :auto
      chef.run_list = ["recipe[" + cookbook_name + "]"]
    end
  end
end
```

And then execute:

    $ bundle exec guard


Authors 
------------
Created and maintained by [Salim Afiune](https://github.com/afiune) (salim@afiunemaya.com.mx) and the community.

