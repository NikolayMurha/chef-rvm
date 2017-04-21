class ChefRvmCookbook
  module RvmProviderMixin
    def rvm
      @rvm ||= ChefRvmCookbook::RvmSimpleEnvironment.new(new_resource.user,
                                                         verbose: node['chef_rvm']['verbose']
                                                         )
    end
  end
end
