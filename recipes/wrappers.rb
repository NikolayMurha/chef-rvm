include_recipe 'chef_rvm::rvm'
node['chef_rvm']['users'].each do |username, rvm|
  next unless rvm['wrappers']
  rvm['wrappers'].each do |gemset, scopes|
    scopes.each do |scope, binaries|
      Array(binaries).each do |binary|
        resource_config = {
          'binary' => binary,
        }
        resource_config = binary if binary.is_a?(Hash)
        chef_rvm_wrapper "rvm:wrapper:#{username}:#{scope}:#{resource_config['binary']}" do
          user username
          ruby_string gemset
          prefix scope
          binary resource_config['binary']
          action resource_config['action'] if resource_config['action']
        end
      end
    end
  end
end
