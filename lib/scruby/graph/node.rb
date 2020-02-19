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
        @inputs = inputs.map &method(:map_constant) >>
                              method(:map_control_name) >>
                              method(:add_control)
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

      def print_name
        name
      end

      private

      def map_constant(elem)
        return elem unless elem.is_a?(Numeric)
        Constant.new(elem).tap { |const| graph.add_constant(const) }
      end

      def map_control_name(name)
        return name unless [ String, Symbol ]
                              .any? { |t| name.is_a?(t) }

        graph.control_name(name)
      end

      def add_control(elem)
        return elem unless elem.is_a?(ControlName)
        graph.add_control(elem)
      end

      def output_index; 0 end
      def special_index; 0 end

      class << self
        def build_root(graph, ugen)
          new(ugen, map_inputs(graph, ugen.input_values).flatten, graph)
        end

        def build(graph, ugen)
          do_build(graph, ugen, ugen.input_values)
        end

        private

        def do_build(graph, ugen, inputs)
          inputs = map_inputs(graph, inputs)

          unless inputs.any? { |i| i.is_a?(Array) }
            return new(ugen, inputs, graph)
          end

          wrapped = inputs.map { |elem| [ *elem ] }
          max_size = wrapped.max_by(&:size).size

          wrapped.map { |elem| elem.cycle.take(max_size) }
            .transpose
            .map { |inputs| do_build(graph, ugen, inputs) }
        end

        def map_inputs(graph, inputs)
          inputs.map &curry(:map_array, graph) >>
                      curry(:map_node, graph)
        end

        def map_array(graph, elem)
          return elem unless elem.is_a?(Array)
          map_inputs(graph, elem)
        end

        def map_node(graph, elem)
          return elem unless elem.is_a?(Ugen::Base)
          build(graph, elem)
        end

        def curry(name, *args)
          method(name).to_proc.curry[*args]
        end
      end
    end
  end
end
