# Alternative LWRP's based rvm cookbook
### Inspired by [RVM](https://github.com/martinisoft/chef-rvm/) cookbook

[![Code Climate](https://codeclimate.com/github/MurgaNikolay/chef-rvm/badges/gpa.svg)](https://codeclimate.com/github/MurgaNikolay/chef-rvm)
[![Build Status](https://travis-ci.org/MurgaNikolay/chef-rvm.svg?branch=master)](https://travis-ci.org/MurgaNikolay/chef-rvm)

### Supported chef-client version:

Chef-Client >= 11.12.0

# LWRP's

### chef_rvm 
```ruby
chef_rvm 'ubuntu'
```

#### Actions

| Action | Description |
|--------|--------------|
| `:install` |  This is default action  |
| `:implode` |                          |
| `:upgrade` |                          |

### chef_rvm_ruby

```ruby
chef_rvm_ruby 'ubuntu:ruby:1.9.3' do
  version '1.9.3'
  patch 'falcon'
  default true
end
```

#### Actions

| Action    | Description   |
|-----------|---------------|
| `:install`   |  This is default action  |
| `:remove`    |               |
| `:uninstall` |               |
| `:reinstall` |               |

### chef_rvm_gemset

```ruby
chef_rvm_gemset 'ubuntu:gemset:1.9.3:test' do
   ruby_string '1.9.3@test'
   user 'ubuntu'
   action :create
end
```

#### Actions

| Action        | Description   |
|---------------|---------------|
| `:create`     |  This is default action  |
| `:delete`     |               |
| `:update`     |               |
| `:pristine`   |               |
| `:prune`      |               |

### chef_rvm_gem

```ruby
chef_rvm_gem 'ubuntu:unicorn' do
   gem 'unicorn'
   user 'ubuntu'
   ruby_string '1.9.3@test'
end
```

#### Actions

| Action        | Description   |
|---------------|---------------|
| `:install`     |  This is default action  |
| `:uninstall`     |               |
| `:update`     |               |

### chef_rvm_wrapper

```ruby
chef_rvm_wrapper 'ubuntu:my_project_unicorn' do
   user 'ubuntu'
   ruby_string '1.9.3@test'
   prefix 'my_project'
   binary 'unicorn'
   action :create
end
```

#### Actions

| Action        | Description   |
|---------------|---------------|
| `:create`     |  This is default action  |
| `:create_or_update`     |               |

### chef_rvm_alias

```ruby    
    chef_rvm_alias 'ubuntu:my_alias' do
       user 'ubuntu'
       alias_name 'my_alias'
       ruby_string '1.9.3@test'
       action :create
    end
```

#### Actions

| Action        | Description   |
|---------------|---------------|
| `:create`     |  This is default action  |
| `:delete`     |               |



#Execute

Execute scripts in rvm environment.
All resources worked like native resources but guards inherit environment from resource by default.

```ruby
    chef_rvm_execute 'bundle install' do
      ruby_string '2.0.0'
      user 'ubuntu'
      cwd '/home/ubuntu/test'
      command 'bundle install'
      not_if 'bundle check'
      action :run
    end
```
```ruby
    chef_rvm_script 'bundle_install_sh' do
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
```

```ruby
    chef_rvm_bash 'bundle_install' do
       ruby_string '2.0.0'
       user 'ubuntu'
       cwd '/home/ubuntu/test'
       code <<CODE
          bundle install
    CODE
      action :run
      not_if 'bundle check'
    end
```

# Attributes
      # Options for .rvmrc
      node['chef_rvm']['rvmrc'] = {
        'rvm_gem_options' => '--no-rdoc --no-ri',
        'rvm_autoupdate_flag' => 0
      }

      # User installations

      node['chef_rvm'] = {
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
            wrappers: {
              :'1.9.3@test' => {
                bootup: [
                  {
                    binary: 'eye',
                    action: 'create_or_update'
                  }
                ]
              },
              :'1.9.3@test2' => {
                bootup: %w(eye unicorn)
              },
              :'1.9.3@test3' => {
                bootup: 'unicorn'
              }
            },
            aliases: {
              'my_alias' => '2.0.0',
              'my_alias_2' => '1.9.3@test2'
            }
          }
        }
      }

# Recipes

    recipe[chef_rvm::default] # Full installations
    recipe[chef_rvm::packages] # Required packages
    recipe[chef_rvm::rvm]
    recipe[chef_rvm::gemsets] # Create gemset
    recipe[chef_rvm::rubies]
    recipe[chef_rvm::gems]
    recipe[chef_rvm::wrappers]
    recipe[chef_rvm::aliases]
    

# Author

Nikolay Murga
