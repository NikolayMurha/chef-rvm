include ChefRvmCookbook::RvmProviderMixin
use_inline_resources

action :create do
  if rvm.alias?(new_resource.alias_name)
    Chef::Log.debug("Alias #{new_resource.alias_name} for user #{new_resource.user} already exists.")
  else
    Chef::Log.debug("Create alias #{new_resource.alias_name} -> #{new_resource.ruby_string} for user #{new_resource.user} already exists.")
    rvm.alias_create(new_resource.alias_name, new_resource.ruby_string)
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if rvm.alias?(new_resource.alias_name)
    Chef::Log.debug("Delete alias #{new_resource.alias_name} -> #{new_resource.ruby_string} for user #{new_resource.user} already exists.")
    rvm.alias_delete(new_resource.alias_name)
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("Alias #{new_resource.alias_name} for user #{new_resource.user} is not exist.")
  end
end
