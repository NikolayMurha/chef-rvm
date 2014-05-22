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
#rvmenv = ::Chef::Cookbook::RVM::Environment.new('ubuntu')

