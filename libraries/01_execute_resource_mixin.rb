class ChefRvmCookbook
  module ExecuteResourceMixin
    def ruby_string(arg = nil)
      set_or_return(
        :ruby_string,
        arg,
        kind_of: [String]
      )
    end
  end
end
