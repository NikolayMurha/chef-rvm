class Chef
  class Resource
    class RvmScript < Chef::Resource::Script
      include ::RvmCookbook::ExecuteResourceMixin
      def initialize(name, run_context = nil)
        super
        @resource_name = :rvm_script
        @ruby_string = 'system'
        @guard_interpreter = :rvm_script
      end

      guard_inherited_attributes(
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
