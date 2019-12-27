module Scruby
  module Ugen
    class DemandEnvGen < Base
      rates :control, :audio
      inputs level: nil, dur: nil, shape: 1, curve: 0, gate: 1, reset: 1, level_scale: 1, level_bias: 0, time_scale: 1, done_action: 0
    end
  end
end
