include_recipe 'ruby_rvm::packages'

node['rvm']['users'].each do |name, options|
  ruby_rvm name do
    action options['action'] if options
  end
end if node['rvm']
