include ChefRvmCookbook::RvmProviderMixin
use_inline_resources

def whyrun_supported?
  true
end

action :create do
  if rvm.gemset?(new_resource.ruby_string)
    Chef::Log.info("Gemset #{new_resource.user} #{new_resource.ruby_string} already exist. Nothing to update.")
  else
    Chef::Log.info("Create gemset #{new_resource.ruby_string} for user #{new_resource.user}.")
    rvm.gemset_create(new_resource.ruby_string)
    rvm.gem_install(new_resource.ruby_string, :bundler)
    new_resource.updated_by_last_action(true)
  end
end

%w(delete update pristine prune).each do |action_name|
  action action_name.to_sym do
    if rvm.gemset?(new_resource.ruby_string)
      Chef::Log.info("#{action_name.capitalize} gemset #{new_resource.ruby_string} for user #{new_resource.user}.")
      rvm.send("gemset_#{action_name}".to_sym, new_resource.ruby_string)
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.info("Gemset #{new_resource.ruby_string} for user #{new_resource.user} is not exist.")
    end
  end
end
