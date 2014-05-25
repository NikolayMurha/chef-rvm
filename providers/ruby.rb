include Chef::DSL::IncludeRecipe
include Chef::Cookbook::RVM::Requirements
include Chef::Cookbook::RVM::EnvironmentFactory

action :install do
  requirements_install(new_resource._version)
  ruby_block "rvm:ruby:#{new_resource.user}:#{new_resource._version}" do
    block do
      Chef::Log.info "Install ruby #{new_resource._version} for user #{new_resource.user}"
      options = {}
      options[:patch] = new_resource.patch if new_resource.patch
      new_resource.updated_by_last_action env.install(new_resource._version, options)
    end
    action :create
    subscribes :create, "rvm[#{new_resource.user}]", :immediately
    not_if {
      env.use(new_resource._version)
    }
  end
  env.use(new_resource._version)
end

[:remove, :uninstall].each do |action_name|
  action action_name do
    requirements_install(new_resource._version)
    ruby_block "rvm:ruby:#{new_resource.user}:#{new_resource._version}" do
      block do
        Chef::Log.info "#{action_name.to_s.capitalize} ruby #{new_resource._version} for user #{new_resource.user}"
        new_resource.updated_by_last_action env.send(action_name, new_resource._version)
      end
      action :create
      subscribes :create, "rvm[#{new_resource.user}]", :immediately
      only_if {
        env.use(new_resource._version)
      }
    end
  end
end
