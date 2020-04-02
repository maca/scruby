require "forwardable"


module Scruby
  class Graph
    class UgenNode
      extend Forwardable

      include Encode
      include Equatable
      include PrettyInspectable

      def_delegators :ugen, :name, :print_name, :rate, :rate_index,
                     :parameter_names, :channel_count,
                     :special_index, :output_specs


      attr_reader :ugen, :inputs, :graph

      def initialize(graph, ugen, inputs)
        @graph = graph
        @ugen = ugen
        @inputs = inputs.map &method(:map_buffer) >>
                              method(:map_boolean) >>
                              method(:map_constant) >>
                              method(:add_constant_inputs) >>
                              method(:map_control_name) >>
                              method(:add_control)
      end

      def encode
        inputs = self.inputs.flat_map { |elem|
          elem.is_a?(Env) ? elem.constants : elem
        }.compact

        [
          encode_string(name),
          encode_int8(rate_index),
          encode_int32(inputs.count),
          encode_int32(channel_count),
          encode_int16(special_index),
          inputs.map { |i| encode_int32_array i.input_specs(graph) },
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

      private

      def map_buffer(elem)
        # no specs for mapping
        return elem unless elem.is_a?(Buffer)
        elem.id
      end

      def map_boolean(elem)
        # no specs for mapping
        case elem
        when false then 0
        when true then 1
        else elem end
      end

      def map_constant(elem)
        return elem unless elem.is_a?(Numeric)
        Constant.new(elem).tap { |const| graph.add_constant(const) }
      end

      def add_constant_inputs(elem)
        elem.encode.map &method(:map_constant) if elem.is_a?(Env)
        elem
      end

      def map_control_name(name)
        return name unless [ String, Symbol ].any? { |t| name.is_a?(t) }
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
