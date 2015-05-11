class ChefRvmCookbook
  class RvmSimpleEnvironment
    def ruby?(ruby_string = nil)
      ruby_string = ruby_string(ruby_string)
      return false unless rvm?
      !rvm(ruby_string.version).error?
    end

    def ruby_install(ruby_string = nil, patch = nil)
      check_rvm!
      ruby_string = ruby_string(ruby_string)
      cmd = "install #{ruby_string.version}"
      cmd << " --patch #{patch}"
      rvm!(:install, ruby_string.version, {timeout: 1000})
    end

    def ruby_set_default(ruby_string = nil)
      check_rvm!
      ruby_string = ruby_string(ruby_string)
      rvm!(ruby_string.version, '--default')
    end

    def ruby_remove(ruby_string = nil)
      check_rvm!
      shell_out!('echo yes | rvm remove', ruby_string(ruby_string).version)
    end

    def check_ruby!(ruby_string = nil)
      check_rvm!
      ruby_string = ruby_string(ruby_string)
      raise RubyDoesNotInstalled.new("Ruby #{ruby_string.version} does not installed. Please install ruby first.", ruby_string) unless ruby?(ruby_string)
      true
    end
  end
end
