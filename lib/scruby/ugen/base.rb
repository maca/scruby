module Scruby
  module Ugen
    class Base
      include Equatable
      include PrettyInspectable
      include Operations
      include Utils::PositionalKeywordArgs
      extend Utils::PositionalKeywordArgs


      def initialize(*args, rate: :audio, **kw)
        defaults = self.class.defaults

        positional_keyword_args(defaults, *args, **kw).map do |key, val|
          send("#{key}=", val.is_a?(Hash) ? val.fetch(rate) : val)
        end

        self.rate = rate
      end

      def rate(rate = nil)
        return @rate if rate.nil?
        dup.tap { |copy| copy.rate = rate }
      end

      def input_values
        inputs.values
      end

      def parameter_names
        inputs.keys
      end

      def rate_index
        E_RATES.index(rate)
      end

      def output_specs #:nodoc:
        [ E_RATES.index(rate) ]
      end

      def channel_count; 1 end
      def inputs; {} end
      def attributes; {} end
      def special_index; 0 end

      def channels(count)
        Ugen::MultiChannel.new([ self ] * count)
      end

      def inspect
        super(rate: rate, **attributes, **inputs)
      end

      def build_graph(**args)
        Graph.new(self, **args)
      end

      def visualize
        build_graph.visualize
      end

      def play(server)
        build_graph.play(server)
      end

      def send_to(server, **args)
        build_graph(**args).send_to(server)
      end

      def out?
        false
      end

      def name
        (self.class.name || "UGen").split("::").last.sub("Ugen", "UGen")
      end

      def print_name
        "#{name} (#{rate})"
      end

      def ==(other)
        self.class == other.class && super
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

        def defaults
          attributes.merge(**inputs)
        end

        private

        def build(rate, *args, **kwargs)
          new(*args, rate: rate, **kwargs)
        end

        def define_accessors(kind, spec)
          dynamic_module = Module.new do
            define_method kind do
              spec.map do |name, _|
                [ name, instance_variable_get("@#{name}") ]
              end.to_h
            end
          end

          spec.each do |name, _|
            define_accessor(dynamic_module, kind, name)
          end

          include dynamic_module
        end

        def define_accessor(dynamic_module, kind, name)
          if kind == :inputs
            dynamic_module.define_method "#{name}=" do |input|
              input = [ *input ]
              input = input.size == 1 ? input.first : input

              instance_variable_set("@#{name}", input)
            end
          else
            dynamic_module.define_method "#{name}=" do |input|
              instance_variable_set("@#{name}", input)
            end
          end

          dynamic_module.define_method name do |input = nil|
            break instance_variable_get("@#{name}") if input.nil?
            dup.tap { |copy| copy.send("#{name}=", input) }
          end

          dynamic_module.send(:protected, "#{name}=")
        end
      end
    end
  end
end
