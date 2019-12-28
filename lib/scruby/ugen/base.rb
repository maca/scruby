module Scruby
  module Ugen
    class Base
      attr_reader :inputs, :rate, :channels

      def initialize(rate: :audio)
        self.rate = rate
      end

      def rate(rate = nil)
        return @rate if rate.nil?
        dup.tap { |copy| copy.rate = rate }
      end

      # Instantiate a new MulAdd passing self and the multiplication
      # and addition arguments
      def muladd(mul, add)
        MulAdd.new(self, mul, add)
      end

      def name
        (self.class.name || "Ugen").split("::").last
      end

      def ==(other)
        self.class == other.class &&
          rate == other.rate &&
          inputs == other.inputs
      end

      def inspect
        "%s(%s, %s)" %
          [ name, rate, inputs.map { |k, v| "#{k}: #{v}" }.join(", ") ]
      end

      def input_values
        inputs.values.flatten
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
          @rates = rates
        end

        def inputs(**specs)
          return @specs || {} if specs.empty?

          define_initialize(specs)
          specs.each { |input_name, _| define_accessor(input_name) }

          define_method :inputs do
            specs.map do |name, _|
              [ name, instance_variable_get("@#{name}") ]
            end.to_h
          end

          @specs = specs
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

        def define_initialize(specs)
          define_method :initialize do |*args, rate: :audio, **kwargs|
            input_names = self.class.inputs.keys

            assigns =
              self.class.inputs.to_a +
                input_names[0...args.size].zip(args) +
                kwargs.to_a

            assigns.map do |name, val|
              self.send("#{name}=", val.is_a?(Hash) ? val[rate] : val)
            end

            super(rate: rate)
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
