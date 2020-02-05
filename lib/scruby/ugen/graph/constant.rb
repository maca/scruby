module Scruby
  module Ugen
    class Graph
      class Constant
        include Scruby::Equatable
        include Scruby::PrettyInspectable

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
          super(value: value)
        end
      end
    end
  end
end
