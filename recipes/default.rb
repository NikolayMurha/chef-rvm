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

node['rvm']['users'].each do |name, ruby|
  rvm name do
    rubies Array(ruby) if ruby
  end
end
