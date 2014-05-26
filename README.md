# rvm cookbook

# Requirements


# Usage


    rvm 'ubuntu' do
       action :install
    end

    rvm_ruby 'ubuntu' do
        version '1.9.3@connect'
        action :install
    end

    rvm_gemset '1.9.3@test' do
       user 'ubuntu'
       action :delete
    end

    rvm_gem 'eye' do
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
