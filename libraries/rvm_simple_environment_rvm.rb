require 'tempfile'
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
        cmd = parent_shell_out("gpg --keyserver #{options[:keyserver] || 'hkp://keyserver.ubuntu.com'} --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3", shell_options)
        cmd.error!

        temp_file = Tempfile.new('foo')
        begin
          parent_shell_out("curl -sSL https://get.rvm.io > #{temp_file.path}").error!
          parent_shell_out("chmod 0777 #{temp_file.path}").error!
          parent_shell_out("bash #{temp_file.path} stable --auto-dotfiles --path '#{rvm_path}'", shell_options).error!
          rvm('autolibs read-fail')
        ensure
          temp_file.close
          temp_file.unlink
        end
      end

      def rvm_implode
        shell_out!('echo yes | rvm implode')
      end

      def rvm_get(version = :stable)
        rvm!(:get, version)
      end

      def check_rvm!
        raise RvmDoesNotInstalled, "Rvm is not installed for user #{user}!" unless rvm?
      end

      alias_method :get, :rvm_get
      alias_method :install, :rvm_install
      alias_method :implode, :rvm_implode
    end
  end
end
