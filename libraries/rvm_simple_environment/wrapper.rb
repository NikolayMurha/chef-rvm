class ChefRvmCookbook
  class RvmSimpleEnvironment
    def wrapper?(prefix, binary)
      ::File.exist?(wrapper_file(prefix, binary))
    end

    def wrapper_create(ruby_string, prefix, binary)
      check_gemset!(ruby_string)
      rvm!(:wrapper, ruby_string, prefix, binary)
    end

    def wrapper_delete(prefix, binary)
      ::File.unlink(wrapper_file(prefix, binary))
    end

    def wrapper_file(prefix, binary)
      ::File.join(rvm_path, 'bin', "#{prefix}_#{binary}")
    end
  end
end
