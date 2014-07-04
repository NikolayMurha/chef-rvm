# rvm cookbook

# Requirements


# LWRP's

    rvm 'ubuntu' do
       action :install
    end
    
| Attributes    | Values           | 
| ------------- |---------------| 
| username      | right-aligned | 
| action      | centered      |

    rvm_ruby '<Resource Name>' do
      version '1.9.3'
      patch 'falcon'
      default true
      action :install
    end

    rvm_gemset '<Resource Name>' do
       ruby_string '1.9.3@test'
       user 'ubuntu'
       action :create
    end

    rvm_gem '<Resource Name>' do
        gem
       user 'ubuntu'
       ruby_string '1.9.3@test'
       action :install
    end

# Attributes


# Recipes

    recipe[default]
    recipe[ruby]
    recipe[gemset]
    recipe[wrapper]

# Author

Author:: R&R Innovation LLC (<cookbooks@randrmusic.com>)
