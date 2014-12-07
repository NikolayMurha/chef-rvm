class Chef
  class Resource
    class RvmBash < Chef::Resource::RvmScript
      def initialize(name, run_context=nil)
        super
        @resource_name = :rvm_bash
        @interpreter = 'bash'
        @guard_interpreter = :rvm_bash
      end

      set_guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :path,
        :user,
        :umask,
        :ruby_string,
        :interpreter
      )
    end
  end
end
