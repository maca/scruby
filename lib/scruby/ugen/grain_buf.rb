module Scruby
  module Ugen
    class GrainBuf < Base
      rates :audio
      inputs num_channels: 1, trigger: 0, dur: 1, sndbuf: nil,
             playback_rate: 1, pos: 0, interp: 2, pan: 0, envbufnum: -1,
             max_grains: 512
    end
  end
end
