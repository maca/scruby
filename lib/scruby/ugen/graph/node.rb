require "forwardable"


module Scruby
  module Ugen
    class Graph
      class Node
        include Scruby::Encode
        extend Forwardable

        def_delegators :object, :inputs, :inputs_count, :rate

        attr_reader :object, :graph

        def initialize(object, graph)
          @object = object
          @graph = graph

          graph.add(self)
        end

        def encode
          [
            encode_string(object.name),

            [ rate_index, inputs_count,
              channels_count, special_index
            ].pack("wn*"),

            collect_input_specs.flatten.pack("n*"),
            output_specs.pack("w*")
          ].join("")
        end

        private

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
          inputs.map { |i| i.input_specs(graph) }
        end

        # def input_specs(_synthdef) #:nodoc:
        #   [ index, output_index ]
        # end
      end
    end
  end
end
