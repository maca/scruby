module Scruby
  module Audio
    module Ugens
      module OperationUgens
        class BasicOpUgen < Ugen #:nodoc:
          attr_accessor :operator

          class << self
            def new( operator, *inputs ) #:nodoc:
              obj = super( get_rate(inputs), *inputs )
              set_operator_for( obj, operator )
              obj
            end

            private
            def set_operator_for( input, operator ) #:nodoc:
              input.instance_of?(Array) ? input.map{ |element| set_operator_for( element, operator )  } : input.operator = operator
            end

            def get_rate( *inputs ) #:nodoc:
              max_index = inputs.flatten.collect{ |ugen| RATES.index( ugen.rate ) }.max
              RATES[max_index]
            end
          end
        end

        class UnaryOpUgen < BasicOpUgen
          def self.new( operator, input )
            super
          end

          def special_index
            UgenOperations::UNARY[ operator.to_sym ]
          end
        end

        class BinaryOpUgen < BasicOpUgen
          def self.new( operator, left, right )
            super
          end

          def special_index
            UgenOperations::BINARY[ operator.to_sym ]
          end
        end

        class MulAdd < Ugen
          def self.new( input, mul, add )
            no_mul = ( mul == 1.0 )
            minus  = ( mul == -1.0 )
            return add         if mul.zero?
            return input       if no_mul && add.zero?
            return input.neg   if minus && add.zero?
            return input * mul if add.zero?
            return add - input if minus
            return input + add if no_mul

            super( input.rate, input, mul, add )
          end
        end
      end
    end
  end
end