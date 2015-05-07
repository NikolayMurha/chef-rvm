include_recipe 'chef_rvm::packages'
node['chef_rvm']['users'].each do |username, rvm|
  rvm['aliases'].each do |alias_name, ruby_string|
    chef_rvm_alias "rvm:#{username}:#{alias_name}" do
      user username
      ruby_string ruby_string
      alias_name alias_name
      action resource_config['action'] if resource_config['action']
    end
  end if rvm['aliases']
end
