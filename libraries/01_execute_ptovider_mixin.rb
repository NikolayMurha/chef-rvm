require_relative 'rvm_provider_mixin'

class ChefRvmCookbook
  module ExecuteProviderMixin
    include ChefRvmCookbook::RvmProviderMixin

    def shell_out!(*args)
      if new_resource.ruby_string
        rvm.rvm_execute!(new_resource.ruby_string, *args)
      else
        super(*args)
      end
    end
  end
end
