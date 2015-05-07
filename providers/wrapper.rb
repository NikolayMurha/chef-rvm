use_inline_resources
include ChefRvmCookbook::RvmProviderMixin

def whyrun_supported?
  true
end

action :create do
  if rvm.wrapper?(new_resource.prefix, new_resource.binary)
    Chef::Log.debug("Wrapper #{new_resource.prefix}_#{new_resource.binary} already exists!")
  else
    Chef::Log.debug("Create wrapper #{new_resource.prefix}_#{new_resource.binary} for #{new_resource.ruby_string}!")
    rvm.wrapper_create(new_resource.ruby_string, new_resource.prefix, new_resource.binary)
    new_resource.updated_by_last_action(true)
  end
end

action :create_or_update do
  if rvm.wrapper?(new_resource.prefix, new_resource.binary)
    Chef::Log.debug("Remove wrapper #{new_resource.prefix}_#{new_resource.binary}")
    rvm.wrapper_delete(new_resource.prefix, new_resource.binary)
  end
  run_action(:create)
  new_resource.updated_by_last_action(true)
end
