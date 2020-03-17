module Scruby
  module Ugen
    class Vibrato < Base
      rates :control, :audio
      inputs freq: 440, playback_rate: 6, depth: 0.02, delay: 0, onset: 0,
 rate_variation: 0.04, depth_variation: 0.1, iphase: 0,
 trig: 0
    end
  end
end
