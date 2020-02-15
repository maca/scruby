module Scruby
  class Graph
    class ControlName
      include Equatable
      include PrettyInspectable
      include Encode

      RATES = %i(scalar control trigger)

      attr_reader :rate, :default, :name

      def initialize(default, rate = :control, name = nil)
        RATES.include?(rate) ||
          raise(ArgumentError,
                "rate `#{rate}` is not one of `#{RATES}`")

        @rate = rate
        @default = default || 0
        @name = name
      end

      def name=(name)
        @name = name.to_sym
      end

      def encode_name(graph)
        [ encode_string(name), encode_int32(index(graph)) ]
      end

      def input_specs(graph)
        [ 0, index(graph) ]
      end

      def inspect
        super(name: name, default: default, rate: rate)
      end

      private

      def index(graph)
        graph.control_index(self)
      end
    end
  end
end
