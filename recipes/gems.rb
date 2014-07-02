
node['rvm']['gems'].each do |user, rubies|
  rubies.each do |ruby, gems|
    gems.each do |gem_name, gem_version|
      rvm_gem "rvm:gem:#{user}:#{ruby}:#{gem_name}" do
        ruby_string ruby
        user user
        gem gem_name
        version gem_version if gem_version
      end
    end
  end
end
