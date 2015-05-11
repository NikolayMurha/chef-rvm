class Chef
  class Provider
    class ChefRvmScript < Chef::Provider::Script
      include ::ChefRvmCookbook::ExecuteProviderMixin
    end
  end
end
