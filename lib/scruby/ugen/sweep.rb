module Scruby
  module Ugen
    class Sweep < Gen
      rates :control, :audio
      inputs trig: 0, playback_rate: 1
    end
  end
end
