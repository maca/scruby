require "forwardable"


module Scruby
  class Graph
    class Node
      extend Forwardable

      include Encode
      include Equatable
      include PrettyInspectable

      def_delegators :ugen, :name, :rate_index, :channels_count,
                     :output_specs


      attr_reader :ugen, :inputs, :graph

      def initialize(ugen, inputs, graph)
        @ugen = ugen
        @graph = graph
        @inputs = map_inputs(inputs, graph).flatten

        graph.add_node(self)
      end

      def encode
        [
          encode_string(name),
          encode_int8(rate_index),
          encode_int32(inputs.count),
          encode_int32(channels_count),
          encode_int16(special_index),
          inputs.map { |i| i.input_specs(graph).pack("N*") },
          output_specs.map { |i| encode_int8(i) }.join
        ].join
      end

      def nodes
        inputs.select { |i| i.is_a?(Node) }
      end

      def constants
        inputs.select { |i| i.is_a?(Constant) }
      end

      def controls
        inputs.select { |i| i.is_a?(ControlName) }
      end

      def input_specs(_)
        [ graph.nodes.index(self), output_index ]
      end

      def inspect
        super(name: name, inputs: inputs)
      end

      private

      def output_index; 0 end
      def special_index; 0 end

      def map_inputs(inputs, graph)
        inputs.map { |e| map_node(e, graph)}
          .map { |e| map_constant(e, graph) }
          .map { |e| map_control_name(e, graph) }
          .map { |e| map_control(e, graph) }
      end

      def map_node(elem, graph)
        return elem unless elem.is_a?(Ugen::Base)
        Node.build(elem, graph)
      end

      def map_constant(elem, graph)
        return elem unless elem.is_a?(Numeric)
        Constant.new(elem).tap { |const| graph.add_constant(const) }
      end

      def map_control_name(name, graph)
        return name unless [ String, Symbol ]
                              .any? { |t| name.is_a?(t) }

        graph.control_name(name)
      end

      def map_control(elem, graph)
        return elem unless elem.is_a?(ControlName)
        graph.add_control(elem) && elem
      end

      class << self
        def build(ugen, graph)
          values = ugen.input_values

          unless values.any? { |e| e.is_a?(Array) }
            return new(ugen, values, graph)
          end

          wrapped = values.map { |elem| [*elem] }
          size = wrapped.max_by(&:size).size

          wrapped.map { |elem| elem.cycle.take(size) }
            .transpose
            .map { |inputs| new(ugen, inputs, graph) }
        end
      end
    end
  end
end
