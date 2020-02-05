require "forwardable"


module Scruby
  module Ugen
    class Graph
      class Node
        include Encode
        include Equatable
        include PrettyInspectable

        attr_reader :value, :inputs, :graph

        def initialize(value, graph)
          @value = value
          @graph = graph
          @inputs = value.input_values
                      .map(&method(:map_node))
                      .map(&method(:map_constant))
                      .map(&method(:map_control))

          graph.add(self)
        end

        def encode
          [
            encode_string(value.name),
            encode_int8(value.rate_index),
            encode_int32(inputs.count),
            encode_int32(value.channels_count),
            encode_int16(special_index),
            inputs.map { |i| i.input_specs(graph).pack("N*") },
            value.output_specs.map { |i| encode_int8(i) }.join
          ].join
        end

        def nodes
          inputs.select { |i| i.is_a?(Node) }
        end

        def constants
          inputs.select { |i| i.is_a?(Constant) }
        end

        def controls
          inputs.select { |i| i.is_a?(Control) }
        end

        def input_specs(_)
          [ graph.nodes.index(self), output_index ]
        end

        def inspect
          super(value: value)
        end

        private

        def map_node(value)
          return value unless value.is_a?(Ugen::Base)
          Node.new(value, graph)
        end

        def map_constant(value)
          return value unless value.is_a?(Numeric)
          Constant.new(value).tap { |const| graph.add_constant(const) }
        end

        def map_control(value)
          case value
          when Symbol, String
            graph.controls.fetch(value)
          else
            value
          end
        end

        def output_index
          # Is it an output?
          0
        end

        def special_index
          0
        end
      end
    end
  end
end
