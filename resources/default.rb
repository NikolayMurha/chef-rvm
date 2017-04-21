puts '******* LOAD CUSTOM RESOURCE *******'

def rvmrc_properties
  node['chef_rvm']['rvmrc'].merge(rvmrc || {})
end

default_action :install

property :user, String, name_property: true
property :rubies, [Hash, Array, String], default: {}
property :rvmrc, [Hash, NilClass], default: nil

action :install do
  puts '>>>>>>>>>>>>>>>>>>>>>>>>>> install'
  unless rvm.rvm?
    rvm.rvm_install
    updated_by_last_action(true)
  end

  rubies = rubies
  if rubies
    rubies = Array(rubies) if rubies.is_a?(String)
    rubies.each do |ruby_string, options|
      options ||= {}
      chef_rvm_ruby "#{user}:#{ruby_string}" do
        user new_resource.user
        version ruby_string
        patch options['patch']
        default options['default']
      end
    end
  end
  create_or_update_rvmvc
end

action :upgrade do
  if rvm.rvm?
    Chef::Log.info "Upgrade RVM for user #{user}"
    rvm.rvm_get(:stable)
    updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{user}"
  end
end

action :implode do
  if rvm.rvm?
    Chef::Log.info "Implode RVM for user #{user}"
    rvm.rvm_implode
    updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{user}"
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper

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
        rvmrc: rvmrc_properties.merge(
          rvm_path: rvm_path
        )
      )
      action :create
    end
  end
end
