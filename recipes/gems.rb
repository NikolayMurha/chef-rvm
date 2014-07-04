include_recipe 'rvm::packages'

node['rvm']['users'].each do |username, rvm_settings|
  rvm_settings['gems'].each do |gemset, gems|
    gems = Array(gems) if gems.is_a?(String)
    gems.each do |gem_name, gem_version|
      if gem_name.is_a?(Hash)
        resource_config = gem_name
      else
        resource_config = {'gem' => gem_name}
      end
      if gem_version.is_a?(Hash)
        resource_config.merge!(gem_version)
      end
      if gem_version.is_a?(String) && !gem_version.blank?
        resource_config.merge!({'version' => gem_version})
      end

      puts '--------GEM-----------'
      puts resource_config
      puts '-------------------'

      rvm_gem "rvm:gem:#{username}:#{gemset}:#{resource_config['name']}" do
        ruby_string gemset
        user username
        gem resource_config['gem']
        version resource_config['version'] if resource_config['version']
        action resource_config['action'] if resource_config['action']
      end
    end
  end if rvm_settings['gems']
end
