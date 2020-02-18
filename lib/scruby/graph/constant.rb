module Scruby
  class Graph
    class Constant
      include Equatable
      include PrettyInspectable
      include PrettyPrint

      attr_reader :value

      def initialize(value)
        @value = value.to_f
      end

      def input_specs(graph)
        [ -1, graph.constants.index(self) ]
      end

      def inspect
        super(value: value)
      end

      private

      def inputs
        []
      end

      def print_name
        value.to_s
      end
    end
  end
end
