default_action :create
property :prefix, String
property :ruby_string, String
property :binary, String
property :user, String

action :create do
  if rvm.wrapper?(prefix, binary)
    Chef::Log.debug("Wrapper #{prefix}_#{binary} already exists!")
  else
    Chef::Log.debug("Create wrapper #{prefix}_#{binary} for #{ruby_string}!")
    rvm.wrapper_create(ruby_string, prefix, binary)
    updated_by_last_action(true)
  end
end

action :create_or_update do
  if rvm.wrapper?(prefix, binary)
    Chef::Log.debug("Remove wrapper #{prefix}_#{binary}")
    rvm.wrapper_delete(prefix, binary)
  end
  run_action(:create)
  updated_by_last_action(true)
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
end
