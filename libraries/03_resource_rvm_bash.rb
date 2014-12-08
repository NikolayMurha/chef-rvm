class Chef
  class Resource
    class RubyRvmBash < Chef::Resource::RubyRvmScript
      def initialize(name, run_context = nil)
        super
        @resource_name = :ruby_rvm_bash
        @interpreter = 'bash'
        @guard_interpreter = :ruby_rvm_bash
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
