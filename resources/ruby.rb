
default_action :install

property :user, [String], required: true
property :version, [Array, String], required: true
property :patch, [String, NilClass], default: nil
property :default, [TrueClass, FalseClass, NilClass], default: nil

action :install do
  if rvm.ruby?(version)
    Chef::Log.debug "Ruby #{version} already installed for user #{user}"
  else
    requirements_install(version)
    Chef::Log.debug "Install ruby #{version} for user #{user}"
    rvm.ruby_install(version, patch)
    rvm.gemset_create(version)
    updated_by_last_action(true)
  end
  rvm.ruby_set_default(version) if default
end

%i[remove uninstall reinstall].each do |action_name|
  action action_name do
    if rvm.ruby?(version)
      Chef::Log.debug "#{action_name.to_s.capitalize} ruby #{version} for user #{user}"
      updated_by_last_action(true)
    else
      Chef::Log.debug "Ruby #{version} is not installed for user #{user}"
    end
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
  include ChefRvmCookbook::Requirements
end
