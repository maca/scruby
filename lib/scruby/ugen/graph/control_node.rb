module Scruby
  module Ugen
    class Graph
      class ControlNode < Ugen::Base
        include Encode

        attr_reader :controls

        def initialize(controls)
          @controls = controls
        end

        def name
          "Control"
        end

        def encode
          [ 7, 67, 111, 110, 116, 114,
            111, 108, 1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 1 ].pack("C*")
        end
      end
    end
  end
end
