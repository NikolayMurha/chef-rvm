# Alternative LWRP's based rvm cookbook
### Inspired by [RVM](http://fnichol.github.com/chef-rvm/) cookbook by [fnichol](https://github.com/fnichol)


[![Build Status](https://travis-ci.org/MurgaNikolay/chef-rvm.svg?branch=master)](https://travis-ci.org/MurgaNikolay/chef-rvm)

### Supported chef-client version:

Chef-Client >= 11.12.0

# LWRP's

    ruby_rvm 'ubuntu' do
       action :install
    end

    ruby_rvm_ruby 'ubuntu:ruby:1.9.3' do
      version '1.9.3'
      patch 'falcon'
      default true
      action :install
    end

    ruby_rvm_gemset 'ubuntu:gemset:1.9.3:test' do
       ruby_string '1.9.3@test'
       user 'ubuntu'
       action :create
    end

    ruby_rvm_gem 'ubuntu:unicorn' do
       gem 'unicorn'
       user 'ubuntu'
       ruby_string '1.9.3@test'
       action :install
    end

#Execute

Execute scripts in rvm environment.
All resources worked like native resources but guards inherit environment from resource by default.


    ruby_rvm_execute 'bundle install' do
      ruby_string '2.0.0'
      user 'ubuntu'
      cwd '/home/ubuntu/test'
      command 'bundle install'
      not_if 'bundle check'
      action :run
    end

    ruby_rvm_script 'bundle_install_sh' do
      interpreter 'sh'
      ruby_string '2.0.0'
      user 'ubuntu'
      cwd '/home/ubuntu/test'
      code <<CODE
        bundle install
    CODE
      not_if 'bundle check'
      action :run
    end

    ruby_rvm_bash 'bundle_install' do
       ruby_string '2.0.0'
       user 'ubuntu'
       cwd '/home/ubuntu/test'
       code <<CODE
          bundle install
    CODE
      action :run
      not_if 'bundle check'
    end


# Attributes
      # Options for .rvmrc
      node['rvm']['rvmrc'] = {
        'rvm_gem_options' => '--no-rdoc --no-ri',
        'rvm_autoupdate_flag' => 0
      }

      # User installations

      node['rvm'] = {
        users: {
          ubuntu: {
            rubies: {
              '1.9.3' => {action: 'install', patch: 'falcon'},
              '2.0' => 'install',
            },
            gems: {
              '1.9.3@test' => %w(eye unicorn),
              '1.9.3@test2' => [
                {gem: 'eye', version: '0.6', action: 'install'},
                'unicorn'
              ],
              '1.9.3@test3' => 'unicorn',
            },
            wrappers:
              {
                :'1.9.3@test' => {
                  bootup: [
                    {
                      binary: 'eye',
                      action: 'update'
                    }
                  ]
                },
                :'1.9.3@test2' => {
                  bootup: %w(eye unicorn)
                },
                :'1.9.3@test3' => {
                  bootup: 'unicorn'
                }
              }
          }
        }
      }

# Recipes

    recipe[ruby_rvm::default] # Full installations
    recipe[ruby_rvm::packages] # Required packages
    recipe[ruby_rvm::rvm]
    recipe[ruby_rvm::rubies]
    recipe[ruby_rvm::gems]
    recipe[ruby_rvm::wrappers]

# Author

Nikolay Murga
