class ChefRvmCookbook
  class RvmSimpleEnvironment
    module Rvm
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
        rvm(ruby_string(args.slice!(0)), :do, *args)
      end

      def do!(*args)
        cmd = self.do(*args)
        cmd.error!
        cmd
      end

      def rvm_execute(*args)
        shell_out("rvm use #{ruby_string(args.slice!(0))};", *args)
      end

      def rvm_execute!(*args)
        cmd = rvm_execute(*args)
        cmd.error!
        cmd
      end

      def rvm_install
        cmd = parent_shell_out('gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3', shell_options)
        cmd.error!

        cmd = parent_shell_out('\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles', shell_options)
        cmd.error!
        cmd
      end

      def rvm_implode
        shell_out!('echo yes | rvm implode')
      end

      def rvm_get(version = :stable)
        rvm!(:get, version)
      end

      def check_rvm!
        raise RvmDoesNotInstalled unless rvm?
      end

      alias_method :get, :rvm_get
      alias_method :install, :rvm_install
      alias_method :implode, :rvm_implode
    end
  end
end
