module Scruby
  module Ugen
    class Base
      include Equatable
      include PrettyInspectable
      include Operations

      attr_reader :inputs, :channels

      def initialize(*args, rate: :audio, **kwargs)
        attribute_names = self.class.attributes.keys
        input_names = self.class.inputs.keys

        assigns =
          self.class.attributes.to_a +
          self.class.inputs.to_a +
          (attribute_names + input_names)[0...args.size].zip(args) +
          kwargs.to_a

        assigns.map do |name, val|
          send("#{name}=", val.is_a?(Hash) ? val.fetch(rate) : val)
        end

        self.rate = rate
      end

      def rate(rate = nil)
        return @rate if rate.nil?
        dup.tap { |copy| copy.rate = rate }
      end

      def name
        (self.class.name || "UGen").split("::").last.sub("Ugen", "UGen")
      end

      def input_values
        inputs.values
      end

      # TODO: no specs
      def rate_index
        E_RATES.index(rate)
      end

      # TODO: no specs
      def output_specs #:nodoc:
        [ E_RATES.index(rate) ]
      end

      # TODO: no specs
      def channels_count; 1 end
      def inputs; {} end
      def attributes; {} end

      def inspect
        super(rate: rate, **attributes, **inputs)
      end

      protected

      def rate=(rate)
        unless self.class.rates.include?(rate.to_sym)
          raise ArgumentError,
                "#{self.class}: #{rate} rate is not allowed"
        end

        @rate = rate
      end

      class << self
        def rates(*rates)
          return [ *@rates ] if rates.empty?
          @rates = rates.flatten
        end

        def inputs(**inputs)
          return @inputs || {} if inputs.empty?
          define_accessors(:inputs, inputs)

          @inputs = inputs
        end

        def attributes(**attributes)
          return @attributes || {} if attributes.empty?
          define_accessors(:attributes, attributes)

          @attributes = attributes
        end

        def ar(*args, **kwargs)
          new(*args, rate: :audio, **kwargs)
        end
        alias audio ar

        def kr(*args, **kwargs)
          new(*args, rate: :control, **kwargs)
        end
        alias control kr

        def ir(*args, **kwargs)
          new(*args, rate: :scalar, **kwargs)
        end
        alias scalar ir

        private

        def define_accessors(kind, spec)
          spec.each { |name, _| define_accessor(name) }

          define_method kind do
            spec.map do |name, _|
              [ name, instance_variable_get("@#{name}") ]
            end.to_h
          end
        end

        def define_accessor(name)
          define_method "#{name}=" do |input|
            instance_variable_set("@#{name}", input)
          end

          define_method name do |input = nil|
            break instance_variable_get("@#{name}") if input.nil?
            dup.tap { |copy| copy.send("#{name}=", input) }
          end

          protected "#{name}="
        end
      end
    end
  end
end
