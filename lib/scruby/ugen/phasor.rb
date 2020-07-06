module Scruby
  module Ugen
    class Phasor < Gen
      rates :control, :audio
      inputs trig: 0, playback_rate: 1, start: 0, finish: 1, reset_pos: 0
    end
  end
end
