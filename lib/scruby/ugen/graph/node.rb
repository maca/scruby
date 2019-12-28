require "forwardable"


module Scruby
  module Ugen
    class Graph
      class Node
        include Scruby::Encode

        attr_reader :constants, :nodes, :value, :graph

        def initialize(value, graph)
          ugens, values =
            value.input_values.partition { |v| v.is_a?(Ugen::Base) }

          @value = value
          @graph = graph
          @nodes = ugens.map { |ugen| Node.new(ugen, graph) }
          @constants = values.map { |val| Constant.new(val, graph) }

          graph.add(self)
        end

        def encode
          [
            encode_string(value.name),
            encode_int8(rate_index),
            encode_int32(inputs.count),
            encode_int32(channels_count),
            encode_int16(special_index),
            collect_input_specs.flatten.pack("N*"),
            output_specs.map { |i| encode_int8(i) }.join
          ].join
        end

        def input_specs
          [ graph.nodes.index(self), output_index ]
        end

        private

        def output_index
          # Is it an output?
          0
        end

        def inputs
          constants + nodes
        end

        def rate
          value.rate
        end

        def special_index
          0
        end

        def channels_count
          1
        end

        def rate_index
          E_RATES.index(rate)
        end

        def output_specs #:nodoc:
          [ E_RATES.index(rate) ]
        end

        def collect_input_specs #:nodoc:
          inputs.map(&:input_specs)
        end

        def inspect
          "#{self.class.name}(#{value})"
        end
      end
    end
  end
end
