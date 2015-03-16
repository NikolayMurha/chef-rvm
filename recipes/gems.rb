include_recipe 'ruby_rvm::packages'

node['rvm']['users'].each do |username, rvm_settings|
  rvm_settings['gems'].each do |gemset, gems|
    gems = Array(gems) if gems.is_a?(String)
    gems.each do |gem_name, gem_version|
      if gem_name.is_a?(Hash)
        resource_config = gem_name
      else
        resource_config = {'gem' => gem_name}
      end

      resource_config.merge!(gem_version) if gem_version.is_a?(Hash)
      resource_config.merge!('version' => gem_version) if gem_version.is_a?(String) && !gem_version.blank?

      ruby_rvm_gem "rvm:gem:#{username}:#{gemset}:#{resource_config['gem']}" do
        ruby_string gemset
        user username
        gem resource_config['gem']
        version resource_config['version'] if resource_config['version']
        action resource_config['action'] if resource_config['action']
      end
    end
  end if rvm_settings['gems']
end
