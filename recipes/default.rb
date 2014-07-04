#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright (C) 2014 R&R Innovation LLC
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'rvm::rvm'
include_recipe 'rvm::rubies'
include_recipe 'rvm::gems'
include_recipe 'rvm::wrappers'

