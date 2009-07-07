module Scruby
  module Audio
    module Ugens
      module OperationUgens
        class BasicOpUgen < Ugen #:nodoc:
          attr_accessor :operator

          class << self
            def new operator, *inputs #:nodoc:
              obj = super get_rate(inputs), *inputs
              set_operator_for obj, operator
              obj
            end

            private
            #:nodoc:
            def set_operator_for input, operator 
              input.kind_of?(Array) ? input.map{ |element| set_operator_for element, operator  } : input.operator = operator
            end

            #:nodoc:
            def get_rate *inputs
              max_index = inputs.flatten.collect{ |ugen| Ugen::RATES.index ugen.rate }.max
              Ugen::RATES[max_index]
            end
          end
        end

        class UnaryOpUgen < BasicOpUgen 
          def self.new operator, input
            super
          end

          def special_index
            UgenOperations::UNARY[ operator.to_sym ]
          end
        end

        class BinaryOpUGen < BasicOpUgen
          def self.new operator, left, right
            super
          end

          def special_index
            UgenOperations::BINARY[ operator.to_sym ]
          end
        end

        class MulAdd < Ugen
          def self.new input, mul, add
            no_mul = ( mul == 1.0 )
            minus  = ( mul == -1.0 )
            return add         if mul == 0
            return input       if no_mul and add == 0
            return input.neg   if minus  and add == 0
            return input * mul if add == 0
            return add - input if minus
            return input + add if no_mul

            super input.rate, input, mul, add
          end
        end
      end
    end
  end
end