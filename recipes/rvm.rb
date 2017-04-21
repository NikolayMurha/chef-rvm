include_recipe 'chef_rvm::packages'
if node['chef_rvm']['users']
  node['chef_rvm']['users'].each do |name, options|
    chef_rvm name do
      action options['action'] if options
    end
  end
end
