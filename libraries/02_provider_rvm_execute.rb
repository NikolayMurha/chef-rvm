class Chef
  class Provider
    class ChefRvmExecute < Chef::Provider::Execute
      include ::ChefRvmCookbook::ExecuteProviderMixin
    end
  end
end
