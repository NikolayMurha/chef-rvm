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

rvm 'ubuntu' do
  rubies %w(1.9.3 2.1)
end

rvm_ruby 'ubuntu' do
  version '1.9.3'
  default true
end

rvm_gem 'unicorn' do
  user 'ubuntu'
  ruby_string '1.9.3@eye'
end
