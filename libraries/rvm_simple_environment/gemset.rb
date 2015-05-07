class ChefRvmCookbook
  class RvmSimpleEnvironment
    def gemset?(*args)
      ruby_string = _gemset_ruby_string(*args)
      !rvm(ruby_string.to_s).error?
    end

    [:create, :prune, :pristine].each do |action|
      define_method "gemset_#{action}" do |*args|
        ruby_string = _gemset_ruby_string(*args)
        check_ruby!(ruby_string)
        cmd = self.do(ruby_string.version, :rvm, :gemset, action, ruby_string.gemset)
        cmd.error!
        cmd
      end
    end

    def gemset_delete(*args)
      ruby_string = _gemset_ruby_string(*args)
      check_ruby!(ruby_string)
      shell_out!('echo yes | rvm', ruby_string.version, :do, :rvm, :gemset, :delete, ruby_string.gemset)
    end

    def _gemset_ruby_string(*args)
      ruby_string = args.compact.join('@')
      # return self.ruby_string if ruby_string.empty?
      self.ruby_string(ruby_string)
    end

    def check_gemset!(ruby_string)
      check_ruby!(ruby_string)
      raise GemsetDoes unless gemset?(ruby_string)
    end
  end
end
