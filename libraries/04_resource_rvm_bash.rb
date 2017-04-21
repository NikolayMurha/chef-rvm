class Chef
  class Resource
    class ChefRvmBash < Chef::Resource::ChefRvmScript
      def initialize(name, run_context = nil)
        super
        provider Chef::Provider::ChefRvmBash
        @resource_name = :chef_rvm_bash
        @interpreter = 'bash'
        @guard_interpreter = :chef_rvm_bash
      end
    end
  end
end
