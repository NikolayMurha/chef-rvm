default_action :create

property :user, [String], default: 'root'
property :ruby_string, [String], required: true, name_property: true

action :create do
  if rvm.gemset?(ruby_string)
    Chef::Log.info("Gemset #{user} #{ruby_string} already exist. Nothing to update.")
  else
    Chef::Log.info("Create gemset #{ruby_string} for user #{user}.")
    rvm.gemset_create(ruby_string)
    rvm.gem_install(ruby_string, :bundler)
    updated_by_last_action(true)
  end
end

%w(delete update pristine prune).each do |action_name|
  action action_name.to_sym do
    if rvm.gemset?(ruby_string)
      Chef::Log.info("#{action_name.capitalize} gemset #{ruby_string} for user #{user}.")
      rvm.send("gemset_#{action_name}".to_sym, ruby_string)
      updated_by_last_action(true)
    else
      Chef::Log.info("Gemset #{ruby_string} for user #{user} is not exist.")
    end
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
end
