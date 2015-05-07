include_recipe 'gpg'
include_recipe 'apt'
include_recipe 'build-essential'
node['chef_rvm']['packages'].each do |package_name|
  package package_name
end
