module Scruby
  module Ugen
    class BinaryOpUgen < Base
      rates Scruby::Ugen::RATES

      attributes operation: nil
      inputs left: nil, right: nil

      def special_index
        Operations.binary_indexes.fetch(operation)
      end
    end
  end
end
