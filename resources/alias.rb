default_action :create

property :user, String, name_property: true
property :alias_name, String
property :ruby_string, String

action :create do
  if rvm.alias?(alias_name)
    Chef::Log.debug("Alias #{alias_name} for user #{user} already exists.")
  else
    Chef::Log.debug("Create alias #{alias_name} -> #{ruby_string} for user #{user}")
    rvm.alias_create(alias_name, ruby_string)
    updated_by_last_action(true)
  end
end

action :deletxe do
  if rvm.alias?(alias_name)
    Chef::Log.debug("Delete alias #{alias_name} -> #{ruby_string} for user #{user}.")
    rvm.alias_delete(alias_name)
    updated_by_last_action(true)
  else
    Chef::Log.debug("Alias #{alias_name} for user #{user} is not exist.")
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
end
