require 'chef/resource'
class Chef
  class Resource
    class ChefRvmExecute < Chef::Resource::Execute
      include ::ChefRvmCookbook::ExecuteResourceMixin

      def initialize(name, run_context = nil)
        if Gem::Version.new(Chef::VERSION) < Gem::Version.new(::ChefRvmCookbook::MIN_SUPPORTED_VERSION)
          raise "Resource 'chef_rvm_execute' is not supported by the Chef Client #{Chef::VERSION}. Please upgrade Chef Client to #{::ChefRvmCookbook::MIN_SUPPORTED_VERSION} or higher."
        end
        super
        @resource_name = :chef_rvm_execute
        @ruby_string = 'system'
        # In chef >= 11.12.0 'execute' resource can not be as guard_interpreter
        # Only 'script' resource or 'script' resource successors.
        @guard_interpreter =
          # Chef 12 can use execute resources as guard_interpreter
          if Chef::Resource::Execute.respond_to?(:set_guard_inherited_attributes)
            :chef_rvm_execute
          else
            :chef_rvm_bash
          end
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
