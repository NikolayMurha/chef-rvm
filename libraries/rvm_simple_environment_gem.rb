class ChefRvmCookbook
  class RvmSimpleEnvironment
    module Gem
      def gem?(ruby_string, gem, version = nil)
        ruby_string = ruby_string(ruby_string)
        check_cmd = "gem list -i ^#{gem}$"
        check_cmd << " -v #{version}" if version
        cmd = shell_out(:rvm, ruby_string.to_s, :do, check_cmd)
        !cmd.error?
      end

      def gem_install(ruby_string, gem, version = nil)
        ruby_string = ruby_string(ruby_string)
        check_gemset!(ruby_string)
        install_cmd = "gem install #{gem}"
        install_cmd << " -v #{version}" if version
        shell_out!(:rvm, ruby_string.to_s, :do, install_cmd)
      end

      def gem_uninstall(ruby_string, gem, version = nil)
        ruby_string = ruby_string(ruby_string)
        check_gemset!(ruby_string)
        uninstall_cmd = "gem uninstall #{gem}"
        uninstall_cmd << " -v #{version}" if version
        shell_out!(:rvm, ruby_string.to_s, :do, uninstall_cmd)
      end
    end
  end
end
