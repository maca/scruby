require "forwardable"


module Scruby
  module Ugen
    class Graph
      class Node
        include Scruby::Encode
        include Scruby::Equatable
        include Scruby::PrettyInspectable

        attr_reader :constants, :nodes, :value, :graph

        def initialize(value, graph)
          grouped = map_inputs(value.input_values)

          init_block = ->(init) { init.call(graph) }

          @value = value
          @graph = graph
          @nodes = grouped[:ugens].map(&init_block)
          @constants = grouped[:values].map(&init_block)

          graph.add(self)
        end

        def encode
          [
            encode_string(value.name),
            encode_int8(value.rate_index),
            encode_int32(inputs.count),
            encode_int32(value.channels_count),
            encode_int16(special_index),
            collect_input_specs.flatten.pack("N*"),
            value.output_specs.map { |i| encode_int8(i) }.join
          ].join
        end

        def input_specs
          [ graph.nodes.index(self), output_index ]
        end

        private

        def map_inputs(inputs)
          hash = Hash.new{ |h, k| h.key?(k) ? h[k] : h[k] = [] }

          inputs.inject(hash) do |acc, input|
            case input
            when Ugen::Base
              acc[:ugens] << Node.method(:new).curry(2).call(input)
            else
              acc[:values] << Constant.method(:new).curry(2).call(input)
            end

            acc
          end
        end

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

        def collect_input_specs #:nodoc:
          inputs.map(&:input_specs)
        end

        def inspect
          super(value: value)
        end
      end
    end
  end
end
