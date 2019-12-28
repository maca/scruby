module Scruby
  module Ugen
    class Graph
      class Constant
        attr_reader :value, :graph

        def initialize(value, graph)
          @value = value
          @graph = graph

          graph.add_constant(self)
        end

        def input_specs
          [ -1, graph.constants.index(self) ]
        end

        def inspect
          "#{self.class.name}(#{value})"
        end
      end
    end
  end
end
