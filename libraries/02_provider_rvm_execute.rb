class Chef
  class Provider
    class RubyRvmExecute < Chef::Provider::Execute
      include ::RvmCookbook::ExecuteProviderMixin
    end
  end
end
