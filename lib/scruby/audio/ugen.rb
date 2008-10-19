module Scruby
  module Audio
    class Ugen
      attr_accessor :inputs, :rate, :index
      
      RATES = [ :scalar, :demand, :control, :audio ]
      @@synthdef = nil

      include UgenOperations
      
      def initialize( rate, *inputs) 
        @rate, @inputs = rate, inputs
        @index = add_to_synthdef
      end
      
      def synthdef
        @synthdef ||= self.class.synthdef
      end
      
      def add_to_synthdef #:nodoc:
        (synthdef.children << self).size - 1 if synthdef
      end

      def to_s
        "a #{self.class}(#{self.inputs.join(', ')})"
      end
      
      def ugen?
        true
      end
      
      def muladd( mul, add )
        MulAdd.new( self, mul, add )
      end

      class << self
        def new( rate, *inputs ) #:nodoc:
          raise ArgumentError.new( "You have to specify Ugen rate and input(s)" ) if inputs.empty?
          raise ArgumentError.new( "#{rate} not a defined rate") unless RATES.include?( rate.to_sym )
          
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