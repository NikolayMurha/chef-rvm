include Chef::Cookbook::RVM::EnvironmentFactory
[:create, :update].each do |action_name|
  action action_name do
    resource_name = "rvm:wrapper:#{new_resource.user}:#{new_resource.prefix}_#{new_resource.binary}"
    wrapper_file = ::File.join(env.config['rvm_path'], 'bin', "#{new_resource.prefix}_#{new_resource.binary}")

    if ::File.exists?(wrapper_file) && action_name == :create
      Chef::Log.debug("Wrapper #{resource_name} exist! So skip!")
      next
    else
      Chef::Log.info("#{action_name.to_s.capitalize} #{resource_name}")
    end

    if env.wrapper new_resource.ruby_string, new_resource.prefix, new_resource.binary
      Chef::Log.debug("Creation/Update of #{resource_name} was successful.")
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.warn("Failed to create/update #{resource_name}.")
    end
  end
end
