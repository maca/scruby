module Scruby
  module Ugen
    class Graph
      class ControlNode
        include Encode

        attr_reader :controls

        def initialize(controls)
          @controls = controls
        end

        def name
          "Control"
        end

        def rate
          :control
        end

        def rate_index
          E_RATES.index(rate)
        end

        def inputs
          []
        end

        def special_index
          0
        end

        def output_specs
          controls.map { |c| E_RATES.index(c.rate) }
        end

        def encode
          [
            encode_string(name),
            encode_int8(rate_index),
            encode_int32(inputs.count),
            encode_int32(controls.count),
            encode_int16(special_index),
            output_specs.map { |i| encode_int8(i) }.join
          ].join
        end
      end
    end
  end
end
