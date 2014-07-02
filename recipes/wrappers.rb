node['rvm']['wrappers'].each do |user, rubies|
  rubies.each do |ruby, wrappers|
    wrappers.each do |scope, binaries|
      Array(binaries).each do |binary|
        rvm_wrapper "rvm:wrapper:#{user}:#{scope}:#{binary}" do
          prefix scope
          ruby_string ruby
          binary binary
          user user
        end
      end
    end
  end
end
