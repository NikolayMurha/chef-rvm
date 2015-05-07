include_recipe 'chef_rvm::packages'
node['chef_rvm']['users'].each do |name, options|
  chef_rvm name do
    action options['action'] if options
  end
end if node['chef_rvm']
