class ChefRvmCookbook
  class RvmSimpleEnvironment
    def gem?(*args)
      ruby_string, gem, version = _gem_params(*args)
      check_cmd = "gem list -i ^#{gem}$"
      check_cmd << " -v #{version}" if version
      cmd = shell_out(:rvm, ruby_string.to_s, :do, check_cmd)
      !cmd.error?
    end

    def gem_install(*args)
      ruby_string, gem, version = _gem_params(*args)
      check_gemset!(ruby_string)
      install_cmd = "gem install #{gem}"
      install_cmd << " -v #{version}" if version
      shell_out!(:rvm, ruby_string.to_s, :do, install_cmd)
    end

    def gem_uninstall(*args)
      check_gemset!(ruby_string)
      ruby_string, gem, version = _gem_params(*args)
      uninstall_cmd = "gem uninstall #{gem}"
      uninstall_cmd << " -v #{version}" if version
      shell_out!(:rvm, ruby_string.to_s, :do, uninstall_cmd)
    end

    def _gem_params(*args)
      [ruby_string(args), args[0], args[1]]
    end
  end
end
