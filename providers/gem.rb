include Chef::Cookbook::RVM::EnvironmentFactory
[:install, :update, :uninstall].each do |action_name|
  action action_name do
    unless env.use(new_resource.ruby_string)
      Chef::Log.debug("Ruby #{new_resource.ruby_string} not installed. So skip!")
      next
    end
    new_resource.updated_by_last_action env.run("gem #{action_name.to_s} #{new_resource.name}").successful?
  end
end
