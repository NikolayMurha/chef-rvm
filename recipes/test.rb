user 'ubuntu'
ruby_rvm 'ubuntu' do
  rubies '2.0.0@test'
end

ruby_rvm_gemset 'iptables_web:gemset' do
  user 'ubuntu'
  ruby_string '2.0.0@test'
end

ruby_rvm_gem 'iptables_web::gem::iptables_web' do
  gem 'iptables_web'
  user 'ubuntu'
  ruby_string '2.0.0@test'
end

# ruby_rvm_execute 'bundle_install' do
#   command env.command('gem list')
#   user env.user
#   environment env.environment
#   cwd env.cwd
#   action :run
# end

ruby_rvm_execute 'ruby_rvm_execute' do
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
#
#
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
