class Chef
  class Provider
    class RvmExecute < Chef::Provider::Execute
      include ::RvmCookbook::ExecuteProviderMixin
    end
  end
end
