node['rvm']['rubies'].each do |username, ruby|
  Array(ruby).each do |ruby_version|
    ruby_version = Chef::Cookbook::RVM::Helpers::RubyString.normalize_ruby_version(ruby_version)
    rvm_ruby "#{username}:#{ruby_version[:version]}" do
      user username
      version ruby_version[:version]
      default ruby_version[:default]
      patch ruby_version[:patch]
    end
  end
end
