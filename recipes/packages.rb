include_recipe 'gpg'
include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'curl'
node['chef_rvm']['packages'].each do |package_name|
  package package_name
end
