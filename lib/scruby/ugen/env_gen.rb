module Scruby
  module Ugen
    class EnvGen < Base
      rates :control, :audio
      inputs envelope: nil, gate: 1, level_scale: 1, level_bias: 0,
             time_scale: 1, done_action: 0

      def inputs
        %i(gate level_scale level_bias time_scale done_action envelope)
          .map { |name| [ name, super.fetch(name) ] }.to_h
      end
    end
  end
end
