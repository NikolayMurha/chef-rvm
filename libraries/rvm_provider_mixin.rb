class ChefRvmCookbook
  module RvmProviderMixin
    def rvm
      @rvm ||= ChefRvmCookbook::RvmSimpleEnvironment.new(new_resource.user,
        verbose: node['chef_rvm']['verbose'],
        keyserver: node['chef_rvm']['keyserver']
      )
    end
  end
end
