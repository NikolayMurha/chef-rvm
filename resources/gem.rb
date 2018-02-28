default_action :install

property :gem, [String]
property :version, [String, NilClass], default: nil
property :user, [String], default: 'root'
property :ruby_string, [String], required: true

action :install do
  unless rvm.gemset?(new_resource.ruby_string)
    Chef::Log.debug('Create gemset before installing gem')
    rvm.gemset_create(new_resource.ruby_string)
  end

  if rvm.gem?(new_resource.ruby_string, new_resource.gem, new_resource.version)
    Chef::Log.debug("Gem #{new_resource.gem} #{new_resource.version} already installed on gemset #{new_resource.ruby_string} for user #{new_resource.user}.")
  else
    Chef::Log.debug("Install gem #{new_resource.gem} #{new_resource.version} on gemset #{new_resource.ruby_string} for user #{new_resource.user}.")
    rvm.gem_install(new_resource.ruby_string, new_resource.gem, new_resource.version)
    updated_by_last_action(true)
  end
end

%i(update uninstall).each do |action_name|
  action action_name do
    if rvm.gem?(new_resource.ruby_string, new_resource.gem, new_resource.version)
      Chef::Log.debug "#{action_name.to_s.capitalize} gem #{new_resource.gem} #{new_resource.version} from gemset #{new_resource.ruby_string} for user #{user}."
      updated_by_last_action(true)
    else
      Chef::Log.debug "Gem #{new_resource.gem} #{new_resource.version} is not installed on gemset #{new_resource.ruby_string} for user #{new_resource.user}."
    end
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
end
