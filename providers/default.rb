include ChefRvmCookbook::RvmProviderMixin
# use_inline_resources
action :install do
  unless rvm.rvm?
    rvm.rvm_install
    # We will have exception on errors, when we set true without check result.
    new_resource.updated_by_last_action(true)
  end

  new_resource.rubies.each do |ruby_string, options|
    options ||= {}
    chef_rvm_ruby "#{new_resource.user}:#{ruby_string}" do
      user new_resource.user
      version ruby_string
      patch options['patch']
      default options['default']
    end
  end if new_resource.rubies
  create_or_update_rvmvc
end

action :upgrade do
  if rvm.rvm?
    Chef::Log.info "Upgrade RVM for user #{new_resource.user}"
    rvm.rvm_get(:stable)
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{new_resource.user}"
  end
end

action :implode do
  if rvm.rvm?
    Chef::Log.info "Implode RVM for user #{new_resource.user}"
    rvm.rvm_implode
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{new_resource.user}"
  end
end

def create_or_update_rvmvc
  if rvm.system?
    rvmrc_file = '/etc/rvmrc'
    rvm_path = '/usr/local/rvm/'
  else
    rvmrc_file = "#{rvm.user_home}/.rvmrc"
    rvm_path = "#{rvm.user_home}/.rvm"
  end

  template rvmrc_file do
    cookbook 'chef_rvm'
    source 'rvmrc.erb'
    owner new_resource.user
    mode '0644'
    variables(
      system_install: rvm.system?,
      rvmrc: new_resource.rvmrc_properties.merge(
        rvm_path: rvm_path
      )
    )
    action :create
  end
end
