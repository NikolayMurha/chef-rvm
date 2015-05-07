class ChefRvmCookbook
  class RvmSimpleEnvironment
    def rvm(*args)
      args.unshift :rvm
      shell_out(*args)
    end

    def rvm!(*args)
      args.unshift :rvm
      shell_out!(*args)
    end

    def rvm?
      @rvm ||= !parent_shell_out("test -f #{rvm_path}/installed.at", shell_options).error?
    end

    def do(*args)
      ruby_string = self.ruby_string(RubyString.fetch(args))
      rvm(ruby_string, :do, *args)
    end

    def do!(*args)
      cmd = self.do(*args)
      cmd.error!
      cmd
    end

    def rvm_execute(*args)
      ruby_string = self.ruby_string(RubyString.fetch(args))
      shell_out("rvm use #{ruby_string};", *args)
    end

    def rvm_execute!(*args)
      cmd = self.rvm_execute(*args)
      cmd.error!
      cmd
    end

    def rvm_install
      parent_shell_out('gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3', shell_options).error!
      cmd = parent_shell_out('\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles', shell_options)
      cmd.error!
      cmd
    end

    def rvm_implode
      shell_out!('echo yes | rvm implode')
    end

    def rvm_get(version=:stable)
      rvm!(:get, version)
    end

    def check_rvm!
      raise RvmDoesNotInstalled.new unless rvm?
    end

    alias_method :get, :rvm_get
    alias_method :install, :rvm_install
    alias_method :implode, :rvm_implode
  end
end
