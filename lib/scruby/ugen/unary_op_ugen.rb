module Scruby
  module Ugen
    class UnaryOpUgen < Base
      rates Scruby::Ugen::RATES
      inputs operation: nil, operand: nil

      def name
        "UnaryOpUGen"
      end

      def special_index
        Operations.unary_indexes.fetch(operation)
      end
    end
  end
end
