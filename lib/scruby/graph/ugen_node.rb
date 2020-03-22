require "forwardable"


module Scruby
  class Graph
    class UgenNode
      extend Forwardable

      include Encode
      include Equatable
      include PrettyInspectable

      def_delegators :ugen, :name, :rate, :rate_index, :channels_count,
                     :special_index, :output_specs


      attr_reader :ugen, :inputs, :graph

      def initialize(graph, ugen, inputs)
        @graph = graph
        @ugen = ugen
        @inputs = inputs.flat_map &method(:map_constant) >>
                                   method(:map_special_input) >>
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
        inputs.select { |i| i.is_a?(UgenNode) }
      end

      def constants
        inputs.select { |i| i.is_a?(Constant) }
      end

      def controls
        inputs.select { |i| i.is_a?(ControlName) }
      end

      def index
        graph.node_index(self)
      end

      def input_specs(_)
        [ index, output_index ]
      end

      def inspect
        super(name: name, inputs: inputs)
      end

      def print_name
        "#{name}(#{rate})"
      end

      private

      def map_constant(elem)
        return elem unless elem.is_a?(Numeric)
        Constant.new(elem).tap { |const| graph.add_constant(const) }
      end

      def map_special_input(elem)
        return elem unless elem.is_a?(Env)
        elem.encode.map &method(:map_constant)
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

      class << self
        def build_root(graph, ugen)
          new(graph, ugen, map_inputs(graph, ugen.input_values).flatten)
        end

        def build(graph, ugen)
          do_build(graph, ugen, ugen.input_values)
        end

        private

        def do_build(graph, ugen, raw_inputs)
          inputs = map_inputs(graph, raw_inputs)

          unless inputs.any? { |i| i.is_a?(Array) }
            return new(graph, ugen, inputs)
          end

          array_inputs(inputs).map { |ins| do_build(graph, ugen, ins) }
        end

        def array_inputs(inputs)
          wrapped = inputs.map { |elem| [ *elem ] }
          max_size = wrapped.max_by(&:size).size

          wrapped.map { |elem| elem.cycle.take(max_size) }.transpose
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
