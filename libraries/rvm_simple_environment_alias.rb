class ChefRvmCookbook
  class RvmSimpleEnvironment
    module Alias
      def alias?(name)
        alias_list.keys.include?(name)
      end

      def alias_create(name, ruby_string)
        ruby_string = ruby_string(ruby_string)
        check_gemset!(ruby_string)
        rvm!(:alias, :create, name, ruby_string)
      end

      def alias_delete(name)
        rvm!(:alias, :delete, name)
      end

      def alias_list
        rvm!('alias list').stdout.split("\n").each_with_object({}) do |item, obj|
          m = item.match(/(.*)=>(.*)/)
          obj[m[1].strip] = m[2].strip if m
        end
      end
    end
  end
end
