include Chef::DSL::IncludeRecipe

action :force_install do
  rvm_install(true)
end

action :install do
  rvm_install
end

action :upgrade do
  puts 'Upgrade rvm!'
end

action :uninstall do
  puts 'Upgrade rvm!'
end

def install_rubies(force=false)
  rubies = Array(new_resource.rubies)
  if rubies.size > 0
    rubies.each do |ruby|
      r = rvm_ruby "#{new_resource.name}::#{ruby}" do
        user new_resource.name
        version ruby
        action force ? :nothing : :install
      end
      r.run_action(:install) if force
    end
  end
end

def rvm_install(force=false)
  include_recipe 'rvm'
  Chef::Log.info "Install RVM for user #{new_resource.user}"

  rvm = execute "Install user RVM for #{new_resource.user}" do
    user new_resource.user
    command '\curl -sSL https://get.rvm.io | bash -s stable && rvm requirements'
    environment rvm_environment
    action force ? :nothing : :run
    not_if "bash -l -c \"type rvm | cat | head -1 | grep -q '^rvm is a function$\"", :environment => rvm_environment
    notifies :remove, "sudo[#{new_resource.user}]"
  end

  #add to sudo
  sudo new_resource.user do
    user      new_resource.user
    nopasswd true
    action force ? :nothing : :install
    notifies :run, rvm
  end
  sudo.run_action(:install) if force
  new_resource.updated_by_last_action(rvm.updated_by_last_action?)
end

def rvm_environment
  env = { 'TERM' => 'dumb' }
  env.merge(
    'USER' => new_resource.user,
    'HOME' => new_resource.user_home
  ) unless new_resource.system?
end
