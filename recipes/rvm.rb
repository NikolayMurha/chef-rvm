include_recipe 'rvm::packages'

node['rvm']['users'].each do |name, options|
  rvm name do
    action options['action'] if options
  end
end if node['rvm']
