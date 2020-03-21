module Scruby
  module Ugen
    class Base
      include Equatable
      include PrettyInspectable
      include Operations
      include Utils::PositionalKeywordArgs


      attr_reader :channels

      def initialize(*args, rate: :audio, **kw)
        defaults = self.class.attributes.merge(self.class.inputs)

        positional_keyword_args(defaults, *args, **kw).map do |key, val|
          send("#{key}=", val.is_a?(Hash) ? val.fetch(rate) : val)
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

      def rate_index
        E_RATES.index(rate)
      end

      def output_specs #:nodoc:
        [ E_RATES.index(rate) ]
      end

      def channels_count; 1 end
      def inputs; {} end
      def attributes; {} end
      def special_index; 0 end

      def inspect
        super(rate: rate, **attributes, **inputs)
      end

      def build_graph(**args)
        Graph.new(self, **args)
      end

      def visualize
        build_graph.visualize
      end

      def demo(server, **args)
        graph = Graph.new(out? ? self : Out.new(0, self))

        Synth.new(graph.name, server).tap do |synth|
          group = Group.new(server, 1)
          graph.send_to(server, synth.creation_message(group))
        end
      end

      def send_to(server, **args)
        build_graph(**args).send_to(server)
      end

      def out?
        false
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
        def inherited(base)
          base.prepend DoneActions
        end

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
