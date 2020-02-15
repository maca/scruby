module Scruby
  module Ugen
    class BinaryOpUgen < Base
      rates Scruby::Ugen::RATES
      inputs operation: nil, left: nil, right: nil

      def name
        "BinaryOpUGen"
      end

      def special_index
        Operations.binary_indexes.fetch(operation)
      end
    end
  end
end
