require 'chef/resource'
class Chef
  class Resource
    class RvmExecute < Chef::Resource::Execute
      include ::RvmCookbook::ExecuteResourceMixin
      def initialize(name, run_context = nil)
        super
        @resource_name = :rvm_execute
        @ruby_string = 'system'
        @guard_interpreter = :rvm_execute
      end

      guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :path,
        :user,
        :umask,
        :ruby_string
      )
    end
  end
end
