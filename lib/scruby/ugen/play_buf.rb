module Scruby
  module Ugen
    class PlayBuf < Base
      rates :control, :audio
      inputs num_channels: nil, bufnum: 0, playback_rate: 1, trigger: 1, start_pos: 0, loop: 0, done_action: 0
    end
  end
end
