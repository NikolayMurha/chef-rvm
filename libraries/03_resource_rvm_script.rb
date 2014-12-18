class Chef
  class Resource
    class RubyRvmScript < Chef::Resource::Script
      include ::RvmCookbook::ExecuteResourceMixin
      def initialize(name, run_context = nil)
        super
        @resource_name = :ruby_rvm_script
        @ruby_string = 'system'
        @guard_interpreter = :ruby_rvm_script
      end

      set_guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :user,
        :umask,
        :ruby_string,
        :interpreter
      )
    end
  end
end
