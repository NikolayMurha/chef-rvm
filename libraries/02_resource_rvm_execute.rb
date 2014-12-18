require 'chef/resource'
class Chef
  class Resource
    class RubyRvmExecute < Chef::Resource::Execute
      include ::RvmCookbook::ExecuteResourceMixin
      def initialize(name, run_context = nil)
        super
        @resource_name = :ruby_rvm_execute
        @ruby_string = 'system'
        @guard_interpreter = :ruby_rvm_bash
      end

      set_guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :user,
        :umask,
        :ruby_string
      )
    end
  end
end
