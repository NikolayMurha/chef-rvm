include_recipe 'chef_rvm::rvm'

node['chef_rvm']['users'].each do |username, rvm|
  next unless rvm['gems']
  rvm['gems'].each do |ruby_string, gems|
    gems = Array(gems) if gems.is_a?(String)
    gems.each do |gem_name|
      resource_config = gem_name.is_a?(Hash) ? gem_name : { 'gem' => gem_name }
      chef_rvm_gem "rvm:gem:#{username}:#{ruby_string}:#{resource_config['gem']}" do
        user username
        ruby_string ruby_string
        gem resource_config['gem']
        version resource_config['version'] if resource_config['version']
        action resource_config['action'] if resource_config['action']
      end
    end
  end
end
