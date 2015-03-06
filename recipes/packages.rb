chef_gem('rvm').run_action(:install)
require 'rvm'
include_recipe 'apt'
include_recipe 'bsw_gpg'

node['chef_rvm']['packages'].each do |package_name|
  package package_name
end
