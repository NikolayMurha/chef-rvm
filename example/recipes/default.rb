include_recipe 'build-essential::default'
include_recipe 'apt'
include_recipe 'chef_rvm'

user 'ubuntu' do
  supports :manage_home => true
  comment 'Ubuntu User'
  home '/home/ubuntu'
  shell '/bin/bash'
end

directory '/home/ubuntu/test' do
  owner 'ubuntu'
end

file '/home/ubuntu/test/Gemfile' do
  content <<EOF
source 'https://rubygems.org'
gem 'rake'
gem 'rails'
gem 'eye'
EOF
end

chef_rvm 'ubuntu' do
  action :install
end

chef_rvm_ruby 'ubuntu:1.9.3' do
  user 'ubuntu'
  version '1.9.3'
end

chef_rvm_ruby 'ubuntu:2.0.0' do
  user 'ubuntu'
  version '2.0.0'
  default true
end

chef_rvm_gemset 'ubuntu:gemset:2.0.0' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
end

chef_rvm_gem 'ubuntu:gem:2.0.0@test:eye' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
  gem 'eye'
  version '0.6.4'
end

chef_rvm_gem 'ubuntu:2.0.0@test:eye:0.6.4' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
  gem 'eye'
  version '0.6.3'
end

chef_rvm_wrapper 'ubuntu:wrapper:prefix_eye' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
  prefix 'prefix'
  binary 'eye'
end

chef_rvm_gem 'ubuntu:2.0.0:bundler' do
  user 'ubuntu'
  ruby_string '2.0.0'
  gem 'bundler'
end

chef_rvm_execute 'bundle install' do
  ruby_string '2.0.0'
  user 'ubuntu'
  cwd '/home/ubuntu/test'
  command 'bundle install'
  not_if 'bundle check'
  action :run
end

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

