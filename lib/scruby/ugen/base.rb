# frozen_string_literal: true

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
        self.class.name.split("::").last
      end

      def inputs_count #:nodoc:
        inputs.size
      end

      def ==(other)
        self.class == other.class && state == other.state
      end

      protected

      def rate=(rate)
        unless self.class.rates.include?(rate.to_sym)
          raise ArgumentError,
                "#{self.class}: #{rate} rate is not allowed"
        end

        @rate = rate
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
end
