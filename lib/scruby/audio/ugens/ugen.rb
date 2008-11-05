module Scruby
  module Audio
    module Ugens
      class Ugen
        attr_reader :inputs, :rate, :index, :special_index, :output_index, :outputs
        
        RATES   = [ :scalar, :trigger, :demand, :control, :audio ]
        E_RATES = [ :scalar, :control, :audio, :demand ]
        @@synthdef = nil

        include UgenOperations

        def initialize( rate, *inputs) 
          @rate, @inputs = rate, inputs.compact
          
          @special_index ||= 0
          @output_index  ||= 0 
          @outputs       ||= [1] 
          
          @index = add_to_synthdef || 0
        end
        
        def muladd( mul, add )
          MulAdd.new( self, mul, add )
        end
        
        def to_s
          "#{self.class} inputs: #{self.inputs.join(', ')}"
        end

        def ugen?
          true
        end

        def encode
          self.class.to_s.split('::').last.encode + [E_RATES.index(rate)].pack('w') + [inputs.size, outputs.size, special_index, collect_input_specs].flatten.pack('n*') + output_specs.pack('w*')
        end
        
        private
        def synthdef
          @synthdef ||= self.class.synthdef
        end

        def add_to_synthdef #:nodoc:
          (synthdef.children << self).size - 1 if synthdef
        end
        
        def collect_constants
          @inputs.send( :collect_constants )
        end
        
        def input_specs( synthdef )
          [index, output_index]
        end
        
        def collect_input_specs
          @inputs.collect{ |i| i.send( :input_specs, synthdef ) }
        end
        
        def output_specs
          [E_RATES.index(rate)]
        end

        class << self
          def new( rate, *inputs ) #:nodoc:
            raise ArgumentError.new( "#{rate} not a defined rate") unless RATES.include?( rate.to_sym )
            inputs.each{ |i| raise ArgumentError.new( "#{i} is not a valid ugen input") unless i.valid_ugen_input? }

            inputs = *inputs #if args is an array peel off one array skin
            inputs = inputs.to_array #may return a non_array object so we turn it into array, does nothing if already array
            size = inputs.select{ |a| a.instance_of? Array }.map{ |a| a.size }.max || 1 #get the size of the largest array element if present
            inputs.flatten! if size == 1 #if there is one or more arrays with just one element flatten the input array
            return instantiate( rate, *inputs ) unless size > 1 #return an Ugen if no array was passed as an input

            inputs = inputs.map{ |argument| argument.instance_of?( Array ) ? argument.wrap_to( size ) : Array.new( size, argument ) }.transpose
            inputs.map{ |new_inputs| new( rate, *new_inputs ) }
          end

          def instantiate( *args ) #:nodoc:
            obj = allocate        
            obj.__send__( :initialize, *args )
            obj
          end

          def synthdef #:nodoc:
            @@synthdef
          end

          def synthdef=( synthdef ) #:nodoc:
            @@synthdef = synthdef
          end
        end
      end
    end
  end

end