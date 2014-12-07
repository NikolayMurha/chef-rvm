class Chef
  class Provider
    class RvmScript < Chef::Provider::Script
      include ::RvmCookbook::ExecuteProviderMixin
    end
  end
end
