module Scruby
  module Ugens
    # All ugens inherit from this "abstract" class
    #
    # == Creation
    #
    # Ugens are usually instantiated inside an "ugen graph" or the
    # block passed when creating a SynthDef using either the ar, kr,
    # ir or new methods wich will determine the rate.
    #
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
    # Usually when instantiating an ugen the arguments can be passed
    # in order:
    #
    #   Pitch.kr(0, 220, 80, ...)
    #
    # Or using a hash where the keys are symbols corresponding to the
    # argument name.
    #
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
    #   class Umaguma < Ugen
    #     class << self
    #       def ar(karma: 200, pitch: 20, rate: 200)
    #         ...
    #       end
    #     end
    #   end
    #
    #
    # TODO: Provide a way of getting the argument names and default
    # values
    class Ugen
      attr_reader :inputs, :rate, :index, :special_index,
                  :output_index, :channels

      RATES        = :scalar, :trigger, :demand, :control, :audio
      E_RATES      = :scalar, :control, :audio, :demand
      VALID_INPUTS = Numeric, Array, Ugen, Env, ControlName
      @@synthdef   = nil


      def initialize(rate, *inputs)
        @rate, @inputs   = rate, inputs.compact
        @special_index ||= 0
        @output_index  ||= 0
        @channels      ||= [1]
        @index           = add_to_synthdef || 0
      end

      # Instantiate a new MulAdd passing self and the multiplication
      # and addition arguments
      def muladd(mul, add)
        MulAdd.new self, mul, add
      end

      def encode
        self.class.to_s.split("::").last.encode +

          [ E_RATES.index(rate) ].pack("w") +

          [ inputs.size, channels.size, special_index,
            collect_input_specs ].flatten.pack("n*") +
          output_specs.pack("w*")
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

      def input_specs(_synthdef) #:nodoc:
        [index, output_index]
      end

      def collect_input_specs #:nodoc:
        @inputs.collect{ |i| i.send :input_specs, synthdef  }
      end

      def output_specs #:nodoc:
        [E_RATES.index(rate)]
      end

      public

      def ==(other)
        self.class == other.class and
          rate     == other.rate     and
          inputs   == other.inputs   and
          channels == other.channels
      end

      class << self
        #:nodoc:

        private

        def new(rate, *inputs)
          if rate.is_a? Array
            rate = RATES.slice rate.collect { |rate|
              # get the highest rate, raise error if rate is not defined
              rate = rate.to_sym

              unless RATES.include? rate
                raise ArgumentError, "#{rate} not a defined rate"
              end

              RATES.index rate
            }.max
          else
            unless RATES.include? rate.to_sym
              raise ArgumentError, "#{rate} not a defined rate"
            end
          end

          size = 1 # Size of the largest multichannel input (Array)
          inputs.peel! # First input if input is Array and size is 1

          inputs.map! do |input|
            if input.respond_to?(:as_ugen_input)
              # Convert input to prefered form
              input = input.as_ugen_input
            end

            unless valid_input? input
              raise ArgumentError,
                    "#{input.inspect} is not a valid ugen input"
            end

            size = input.size if input.size > size if input.is_a? Array
            input
          end

          # return an Ugen if no array was passed as an input
          return super( rate, *inputs.flatten ) unless size > 1

          inputs.map! do |input|
            if Array === input
              input.wrap_to(size)
            else
              Array.new(size, input)
            end
          end

          output = inputs.transpose

          output.map! { |new_inputs| new(rate, *new_inputs) }
          output.to_da
        end

        public

        def valid_input?(obj)
          case obj
          when *VALID_INPUTS then true
          else false
          end
        end

        def synthdef #:nodoc:
          @@synthdef
        end

        def synthdef=(synthdef) #:nodoc:
          @@synthdef = synthdef
        end

        def params
          {}
        end
      end
    end
  end
end
