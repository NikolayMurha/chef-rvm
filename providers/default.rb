include Chef::DSL::IncludeRecipe
include Chef::Cookbook::RVM::Helpers

action :install do
  include_recipe 'rvm' #install packages
  Chef::Log.info "Install RVM for user #{new_resource.user}"
  check_command = "bash -l -c \"type rvm | cat | head -1 | grep -q '^rvm is a function$'\""
  rvm = execute "rvm:rvm:#{new_resource.user}" do
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
      subscribes :install, rvm, :immediately
      only_if check_command, :environment => rvm_environment
    end
  end

  install_rvmvc
end

action :upgrade do
  puts 'Upgrade rvm!'
end

action :uninstall do
  puts 'Upgrade rvm!'
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
