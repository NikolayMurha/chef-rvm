class Chef
  class Provider
    class RubyRvmScript < Chef::Provider::Script
      include ::RvmCookbook::ExecuteProviderMixin
    end
  end
end
