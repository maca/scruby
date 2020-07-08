module Scruby
  module Ugen
    class UnaryOpUgen < Operation
      attributes operation: nil
      inputs operand: nil

      class << self
        def apply(operation, operand)
          UnaryOpUgen.new(operation, operand, rate: operand.rate)
        end
      end
    end
  end
end
