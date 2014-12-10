class RvmCookbook
  module ExecuteResourceMixin
    module ClassMethod
      def set_guard_inherited_attributes(*inherited_attributes)
        @class_inherited_attributes = inherited_attributes
      end

      def guard_inherited_attributes(*inherited_attributes)
        # Similar to patterns elsewhere, return attributes from this
        # class and superclasses as a form of inheritance
        ancestor_attributes = []

        if superclass.respond_to?(:guard_inherited_attributes)
          ancestor_attributes = superclass.guard_inherited_attributes
        end
        ancestor_attributes.concat(@class_inherited_attributes ? @class_inherited_attributes : []).uniq
      end
    end
    extend ClassMethod

    def ruby_string(arg = nil)
      set_or_return(
        :ruby_string,
        arg,
        :kind_of => [String]
      )
    end
  end
end
