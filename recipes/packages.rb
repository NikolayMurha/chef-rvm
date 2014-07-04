chef_gem('rvm').run_action(:install)
require 'rvm'
node['rvm']['packages'].each do |package_name|
  package package_name
end
