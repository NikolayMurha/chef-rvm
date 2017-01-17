include_recipe 'chef_rvm::rvm'
node['chef_rvm']['users'].each do |username, rvm|
  ruby_strings = []
  ruby_strings |= rvm['gems'].keys if rvm['gems']
  ruby_strings |= rvm['wrappers'].keys if rvm['wrappers']
  ruby_strings |= rvm['aliases'].values if rvm['aliases']
  ruby_strings.uniq!

  next if ruby_strings.empty?
  ruby_strings.each do |ruby_string|
    chef_rvm_gemset "#{username}:gemset:#{ruby_string}" do
      user username
      ruby_string ruby_string
    end
  end
end
