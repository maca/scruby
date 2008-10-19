module Scruby
  module Audio
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
        
      end
    end
  end
end