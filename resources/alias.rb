default_action :create

property :user, String, name_property: true
property :alias_name, String
property :ruby_string, String

action :create do
  if rvm.alias?(new_resource.alias_name)
    Chef::Log.debug("Alias #{new_resource.alias_name} for user #{new_resource.user} already exists.")
  else
    Chef::Log.debug("Create alias #{new_resource.alias_name} -> #{new_resource.ruby_string} for user #{new_resource.user}")
    rvm.alias_create(new_resource.alias_name, new_resource.ruby_string)
    updated_by_last_action(true)
  end
end

action :delete do
  if rvm.alias?(new_resource.alias_name)
    Chef::Log.debug("Delete alias #{new_resource.alias_name} -> #{new_resource.ruby_string} for user #{new_resource.user}.")
    rvm.alias_delete(new_resource.alias_name)
    updated_by_last_action(true)
  else
    Chef::Log.debug("Alias #{new_resource.alias_name} for user #{new_resource.user} is not exist.")
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
end
