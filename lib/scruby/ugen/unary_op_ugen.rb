module Scruby
  module Ugen
    class UnaryOpUgen < Base
      rates Scruby::Ugen::RATES

      attributes operation: nil
      inputs operand: nil

      def special_index
        Operations.unary_indexes.fetch(operation)
      end
    end
  end
end
