class RvmCookbook
  module ExecuteResourceMixin
    def ruby_string(arg = nil)
      set_or_return(
        :ruby_string,
        arg,
        :kind_of => [String]
      )
    end

    module ClassMethod
      def guard_inherited_attributes(*inherited_attributes)
        @class_inherited_attributes = inherited_attributes if inherited_attributes

        ancestor_attributes = []
        if superclass.respond_to?(:guard_inherited_attributes)
          ancestor_attributes = superclass.guard_inherited_attributes
        end
        ancestor_attributes.concat(@class_inherited_attributes ? @class_inherited_attributes : []).uniq
      end
    end
  end
end
