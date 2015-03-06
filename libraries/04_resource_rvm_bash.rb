class Chef
  class Resource
    class RubyRvmBash < Chef::Resource::RubyRvmScript
      def initialize(name, run_context = nil)
        super
        @resource_name = :chef_rvm_bash
        @interpreter = 'bash'
        @guard_interpreter = :chef_rvm_bash
      end
    end
  end
end
