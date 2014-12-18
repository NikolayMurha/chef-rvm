user 'ubuntu' do
  home '/home/ubuntu'
  supports :manage_home => true
end

ruby_rvm 'ubuntu' do
  rubies '2.0.0@iptables_web'
end

ruby_rvm_gemset 'iptables_web:gemset' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
end

ruby_rvm_gem 'iptables_web::gem::iptables_web' do
  gem 'iptables-web'
  user 'ubuntu'
  ruby_string '2.0.0@test'
end

directory '/home/ubuntu/test' do
  owner 'ubuntu'
  group 'ubuntu'
end

file '/home/ubuntu/test/Gemfile' do
  owner 'ubuntu'
  group 'ubuntu'
  content <<FILE
source 'https://rubygems.org'
gem 'rake'
FILE
end

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
