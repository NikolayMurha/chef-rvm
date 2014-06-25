include Chef::DSL::IncludeRecipe
include Chef::Cookbook::RVM::Helpers
include Chef::Mixin::ShellOut

def whyrun_supported?
  true
end

use_inline_resources

action :install do
  include_recipe 'rvm'
  Chef::Log.info "Install RVM for user #{new_resource.user}"
  execute "rvm:rvm:#{new_resource.user}" do
    user new_resource.user
    command '\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles'
    environment rvm_environment
    action :run
    not_if check_command, :environment => rvm_environment
  end
  Array(new_resource.rubies).each do |rubie|
    rvm_ruby "#{new_resource.user}:#{rubie}" do
      user new_resource.user
      version rubie
    end
  end
  install_rvmvc
end

action :upgrade do
  Chef::Log.info "Upgrade RVM for user #{new_resource.user}"
  execute "rvm:rvm:#{new_resource.user}" do
    user new_resource.user
    command 'rvm get stable'
    environment rvm_environment
    action :run
    only_if check_command, :environment => rvm_environment
  end
end

action :uninstall do
  check_command = "bash -l -c \"type rvm | cat | head -1 | grep -q '^rvm is a function$'\""
  Chef::Log.info "Upgrade RVM for user #{new_resource.user}"
  execute "rvm:rvm:#{new_resource.user}" do
    user new_resource.user
    command 'rvm implode'
    environment rvm_environment
    action :run
    only_if check_command, :environment => rvm_environment
  end
end

def install_rvmvc
  if new_resource.system?
    rvmrc_file = '/etc/rvmrc'
    rvm_path = '/usr/local/rvm/'
  else
    rvmrc_file = "#{new_resource.user_home}/.rvmrc"
    rvm_path = "#{new_resource.user_home}/.rvm"
  end

  template rvmrc_file do
    cookbook 'rvm'
    source 'rvmrc.erb'
    owner new_resource.user
    mode '0644'
    variables  system_install: new_resource.system?,
      rvmrc: new_resource.get_rvmrc.merge({
        rvm_path: rvm_path
      })
    action :create
  end
end

def rvm_environment
  env = { 'TERM' => 'dumb' }
  env.merge(
    'USER' => new_resource.user,
    'HOME' => new_resource.user_home
  ) unless new_resource.system?
end

def check_command
  "bash -l -c \"type rvm | cat | head -1 | grep -q '^rvm is a function$'\""
end
