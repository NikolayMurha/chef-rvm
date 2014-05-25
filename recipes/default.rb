#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright (C) 2014 R&R Innovation LLC
#
# All rights reserved - Do Not Redistribute
#
chef_gem('rvm').run_action(:install)
require 'rvm'
node['rvm']['packages'].each do |package_name|
  package package_name
end

# rvm 'ubuntu' do
#   action :install
# end

# rvm_ruby 'ubuntu' do
#    version '1.9.3@connect'
#    action :install
# end

rvm_gemset '1.9.3@test' do
   user 'ubuntu'
   action :delete
end

rvm_gemset '1.9.3@connect' do
  user 'ubuntu'
  action :delete
end

# rvm_gem 'eye' do
#   user 'ubuntu'
#   ruby_string '1.9.3@default'
#   action :install
# end
