module Scruby
  class Sclang
    module Helpers
      module_function

      def literal(value)
        case value
        when String, TrueClass, FalseClass, NilClass, Numeric
          value.inspect
        when Symbol
          "'#{value}'"
        else
          raise(ArgumentError,
                "#{value.inspect} is not of a valid server option type")
        end
      end

      def camelize(str)
        str.split("_").each_with_index
          .map { |s, i| i.zero? ? s : s.capitalize }.join
      end
    end
  end
end
