module Scruby
  module Ugen
    class Graph
      class Control
        include Equatable
        include PrettyInspectable

        RATES = %i(scalar control trigger)

        attr_reader :rate, :default

        def initialize(default, rate = :control)
          RATES.include?(rate) ||
            raise(ArgumentError,
                  "rate `#{rate}` is not one of `#{RATES}`")

          @rate = rate
          @default = default
        end

        def input_specs(graph)
          [ 0, graph.controls.values.index(self) ]
        end

        def inspect
          super(default: default, rate: rate)
        end
      end
    end
  end
end
