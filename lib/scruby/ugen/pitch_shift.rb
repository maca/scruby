module Scruby
  module Ugen
    class PitchShift < Base
      rates :audio
      inputs input: 0, window_size: 0.2, pitch_ratio: 1,
             pitch_dispersion: 0, time_dispersion: 0
    end
  end
end
