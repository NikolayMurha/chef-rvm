include Chef::Cookbook::RVM::EnvironmentFactory
[:install, :update, :uninstall].each do |action_name|
  action action_name do
    Chef::Log.debug("#{action_name.to_s.capitalize} #{new_resource.gem} in #{new_resource.ruby_string} from user #{new_resource.user}")
    raise "Can't install gem #{new_resource.gem} because ruby #{new_resource._version} not installed!" unless env.use(new_resource._version)
    if new_resource._gemset
      unless env.gemset_use(new_resource._gemset)
        Chef::Log.info("Create gemset for #{new_resource.ruby_string}!")
        env.gemset_create(new_resource._gemset)
      end
      raise "Can't change environment to #{new_resource.ruby_string} for install gem #{new_resource.gem}" unless env.gemset_use(new_resource._gemset)
    end

    if action_name == :install && env.run("gem which #{new_resource.gem}").successful?
      Chef::Log.debug("Gem #{new_resource.gem} alredy installed! So skip!")
      next
    end
    new_resource.updated_by_last_action env.run("gem #{action_name.to_s} #{new_resource.gem}").successful?
  end
end
