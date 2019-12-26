# frozen_string_literal: true

module Scruby
  class Ugen
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
    include Scruby::Encode

    attr_reader :inputs, :rate, :index, :special_index,
                :output_index, :channels

    RATES      = %i(scalar trigger demand control audio).freeze
    E_RATES    = %i(scalar control audio demand).freeze
    @@synthdef = nil

    class RateError < StandardError
    end

    def initialize(rate: :audio)
      self.rate = rate
      @index = add_to_synthdef || 0
    end

    def special_index
      @special_index || 0
    end

    def output_index
      @output_index || 0
    end

    def channels
      @output_index || [ 1 ]
    end

    # Instantiate a new MulAdd passing self and the multiplication
    # and addition arguments
    def muladd(mul, add)
      MulAdd.new(self, mul, add)
    end

    def encode
      [
        encode_string(self.class.name.split("::").last),
        [ E_RATES.index(rate) ].pack("w"),
        [ inputs.size, channels.size, special_index ].pack("n*"),
        collect_input_specs.flatten.pack("n*"),
        output_specs.pack("w*")
      ].join("")
    end

    def synthdef #:nodoc:
      @synthdef ||= Ugen.synthdef
    end

    def input_specs(_synthdef) #:nodoc:
      [ index, output_index ]
    end

    def ==(other)
      self.class == other.class && state == other.state
    end

    def rate(rate = nil)
      return @rate if rate.nil?
      dup.tap { |copy| copy.rate = rate }
    end

    protected

    def rate=(rate)
      unless self.class.rates.include?(rate.to_sym)
        raise RateError, "#{self.class}: #{rate} rate is not allowed"
      end
      @rate = rate
    end

    def add_to_synthdef #:nodoc:
      (synthdef.children << self).size - 1 if synthdef
    end

    def constants #:nodoc:
      inputs.map(&:constants)
    end

    def collect_input_specs #:nodoc:
      inputs.map { |i| i.input_specs(synthdef) }
    end

    def output_specs #:nodoc:
      [ E_RATES.index(rate) ]
    end

    def state
      instance_variables.map { |var| instance_variable_get var }
    end

    class << self
      def rates(*rates)
        return [*@rates] if rates.empty?
        @rates = rates
      end

      def inputs(specs)
        define_initialize(specs)
        specs.each { |input_name, _| define_accessor(input_name) }

        define_method :inputs do
          specs.map { |name, _| instance_variable_get("@#{name}") }
        end
      end

      def ar(**params)
        new(**params, rate: :audio)
      end
      alias audio ar

      def kr(**params)
        new(**params, rate: :control)
      end
      alias control kr

      def ir(**params)
        new(**params, rate: :scalar)
      end
      alias scalar ir

      def synthdef #:nodoc:
        @@synthdef
      end

      def synthdef=(synthdef) #:nodoc:
        @@synthdef = synthdef
      end

      private

      def define_initialize(specs)
        args = [ "rate: :audio", *specs.map { |k, v| "#{k}: #{v}" } ]
        assigns = *specs.map { |k, _| "self.#{k} = #{k}" }

        class_eval <<-RUBY
          def initialize(#{args.join(', ')})
            #{assigns.join(';')}
            super(rate: rate)
          end
        RUBY
      end

      def define_accessor(name)
        define_method "#{name}=" do |input|
          instance_variable_set("@#{name}", Input.wrap(input))
        end

        define_method name do |input = nil|
          break instance_variable_get("@#{name}")&.value if input.nil?
          dup.tap { |copy| copy.send("#{name}=", input) }
        end

        protected "#{name}="
      end
    end
  end
end
