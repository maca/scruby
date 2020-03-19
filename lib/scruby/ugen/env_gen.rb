module Scruby
  module Ugen
    class EnvGen < Base
      rates :control, :audio
      inputs envelope: nil, gate: 1, level_scale: 1, level_bias: 0,
             time_scale: 1, done_action: 0

      def input_values
        [ *super[1..-1], super.first ]
      end
    end
  end
end
