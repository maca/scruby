module Scruby
  module Ugen
    class Graph
      class Constant
        include Equatable
        include PrettyInspectable

        attr_reader :value

        def initialize(value)
          @value = value
        end

        def input_specs(graph)
          [ -1, graph.constants.index(self) ]
        end

        def inspect
          super(value: value)
        end
      end
    end
  end
end
