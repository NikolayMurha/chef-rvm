include_recipe 'chef_rvm::rvm'
node['chef_rvm']['users'].each do |username, rvm_settings|
  ruby_strings = []
  ruby_strings = ruby_strings | rvm_settings['gems'].keys if rvm_settings['gems']
  ruby_strings = ruby_strings | rvm_settings['wrappers'].keys if rvm_settings['wrappers']
  ruby_strings = ruby_strings | rvm_settings['aliases'].values if rvm_settings['aliases']
  ruby_strings.uniq!

  next if ruby_strings.size == 0
  ruby_strings.each do |ruby_string|
    chef_rvm_gemset "#{username}:gemset:#{ruby_string}" do
      user username
      ruby_string ruby_string
    end
  end
end
