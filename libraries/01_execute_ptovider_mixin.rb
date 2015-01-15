class RvmCookbook
  module ExecuteProviderMixin
    def rvm
      @env ||= ::RvmCookbook::ShellHelper.new(new_resource.user, new_resource.ruby_string)
    end

    def shell_out!(*args)
      arguments = rvm.shell_out_args(*args)
      Chef::Log.debug "Call: #{arguments.join(', ')}"
      r = super(*arguments)
      Chef::Log.debug "STDOUT: #{r.stdout.to_s.strip}"
      Chef::Log.debug "STDERR: #{r.stderr}" unless r.stderr.to_s.empty?
      r
    end
  end
end
