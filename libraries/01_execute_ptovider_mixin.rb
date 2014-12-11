class RvmCookbook
  module ExecuteProviderMixin
    def rvm
      @env ||= ::RvmCookbook::ShellHelper.new(new_resource.user, new_resource.ruby_string)
    end

    def shell_out!(*args)
      Chef::Log.debug "Call #{rvm.shell_out_args(*args)}"
      r = super(*rvm.shell_out_args(*args))
      Chef::Log.debug "STDOUT: #{r.stdout}"
      Chef::Log.debug "STDERR: #{r.stderr}"
      r
    end
  end
end
