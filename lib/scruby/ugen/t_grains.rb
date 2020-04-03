module Scruby
  module Ugen
    class TGrains < Base
      rates :audio
      attributes channel_count: 1

      inputs trigger: 0, bufnum: 0, playback_rate: 1, center_pos: 0,
             dur: 0.1, pan: 0, amp: 0.1, interp: 4
    end
  end
end
