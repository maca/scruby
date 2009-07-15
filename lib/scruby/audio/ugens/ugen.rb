module Scruby
  module Audio
    module Ugens
      # All ugens inherit from this "abstract" class
      #
      # == Creation
      #
      # Ugens are usually instantiated inside an "ugen graph" or the block passed when creating a SynthDef 
      # using either the ar, kr, ir or new methods wich will determine the rate.
      #   * ar: audio rate
      #   * kr: control rate
      #   * ir: scalar rate
      #   * new: demand rate
      #
      # Not all the ugens provide all the rates
      #
      # Two ugens inside an ugen graph: 
      #   SynthDef.new('simple'){ Out.ar(0, SinOsc.ar) }
      #   # Out and SinOsc are both ugens
      #
      #
      # == Passing arguments when creating
      #
      # Usually when instantiating an ugen the arguments can be passed in order:
      #   Pitch.kr(0, 220, 80, ...)
      #
      # Or using a hash where the keys are symbols corresponding to the argument name. 
      #   Pitch.kr( :initFreq => 220, :execFreq => 300 )
      #
      # Or a combination of both ways:
      #   Pitch.kr(0, 220, :execFreq => 300)
      #
      # Arguments not passed in either way will resort to default
      #
      #
      # == Defining ugens
      #
      # This named arguments functionality is provided for all the default Ugens but can be provided when defining a new Ugen by calling
      # <tt>#named_arguments_for</tt> passing a symbol with the name of a defined method:
      #
      #   class Umaguma < Ugen
      #     class << self
      #       def ar(karma = 200, pitch = 20, rate = 200)
      #         ...
      #       end
      #       named_arguments_for :ar
      #     end
      #     
      #   end
      #
      # For more info and limitations on named arguments check the gem: http://github.com/maca/namedarguments/tree/master
      #
      # Otherwise usage is pretty the same as in SuperCollider
      #
      # TODO: Provide a way of getting the argument names and default values
      class Ugen
        attr_reader :inputs, :rate, :index, :special_index, :output_index, :channels
        
        RATES   = [ :scalar, :trigger, :demand, :control, :audio ]
        E_RATES = [ :scalar, :control, :audio, :demand ]
        @@synthdef = nil

        def initialize rate, *inputs
          @rate, @inputs = rate, inputs.compact
          
          @special_index ||= 0
          @output_index  ||= 0 
          @channels      ||= [1] 
          
          @index = add_to_synthdef || 0
        end
        
        # Instantiate a new MulAdd passing self and the multiplication and addition arguments
        def muladd mul, add
          MulAdd.new self, mul, add
        end
        
        # Demodulized class name
        def to_s
          "#{self.class.to_s.split('::').last}"
        end
        
        def encode
          self.class.to_s.split('::').last.encode + [ E_RATES.index(rate) ].pack('w') + 
            [ inputs.size, channels.size, special_index, collect_input_specs ].flatten.pack('n*') + 
            output_specs.pack('w*')
        end
        
        private
        def synthdef #:nodoc:
          @synthdef ||= Ugen.synthdef
        end

        def add_to_synthdef #:nodoc:
          (synthdef.children << self).size - 1 if synthdef
        end
        
        def collect_constants #:nodoc:
          @inputs.send( :collect_constants )
        end
        
        def input_specs synthdef #:nodoc:
          [index, output_index]
        end
        
        def collect_input_specs #:nodoc:
          @inputs.collect{ |i| i.send :input_specs, synthdef  }
        end
        
        def output_specs #:nodoc:
          [E_RATES.index(rate)]
        end

        class << self
          def valid_input? obj
            not [Ugen, ControlName, Env, UgenOperations].collect do |m|
              true if obj.kind_of? m
            end.compact.empty?
          end
          
          #:nodoc:
          def new rate, *inputs 
            raise ArgumentError.new( "#{rate} not a defined rate") unless RATES.include?( rate.to_sym )

            inputs.each{ |i| raise ArgumentError.new( "#{i} is not a valid ugen input") unless valid_input?(i) }
            inputs.peel!

            size   = inputs.select{ |a| a.kind_of? Array }.map{ |a| a.size }.max || 1 #get the size of the largest array element if present
            inputs.flatten! if size == 1 #if there is one or more arrays with just one element flatten the input array
            return instantiate( rate, *inputs ) unless size > 1 #return an Ugen if no array was passed as an input

            inputs = inputs.map{ |input| input.instance_of?( Array ) ? input.wrap_to( size ) : Array.new( size, input ) }.transpose
            inputs.map{ |new_inputs| new rate, *new_inputs }
          end
          
          #:nodoc:
          def instantiate *args 
            obj = allocate        
            obj.__send__ :initialize, *args
            obj
          end

          #:nodoc:
          def synthdef
            @@synthdef
          end

          def synthdef= synthdef #:nodoc:
            @@synthdef = synthdef
          end
        end
      end
    end
  end

end