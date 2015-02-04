include Chef::DSL::IncludeRecipe
include RvmCookbook::Requirements
include RvmCookbook::EnvironmentFactory

use_inline_resources

def whyrun_supported?
  true
end

action :install do
  requirements_install(new_resource._version)
  Chef::Log.debug "Install ruby #{new_resource._version} for user #{new_resource.user}"
  unless check_and_set_default
    options = {:rvm_by_path => true}
    options[:patch] = new_resource.patch if new_resource.patch
    raise "Ruby #{new_resource._version} can't be installed" unless env.install(new_resource._version, options)
    new_resource.updated_by_last_action true
    check_and_set_default
  end
end

[:remove, :uninstall].each do |action_name|
  action action_name do
    requirements_install(new_resource._version)
    Chef::Log.debug "#{action_name.to_s.capitalize} ruby #{new_resource._version} for user #{new_resource.user}"
    if env.use(new_resource._version)
      new_resource.updated_by_last_action env.send(action_name, new_resource._version)
    end
  end
end

def check_and_set_default
  env.rvm(:use, new_resource._version, ('--default' if new_resource.default)).successful?
end
