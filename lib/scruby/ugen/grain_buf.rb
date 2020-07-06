module Scruby
  module Ugen
    class GrainBuf < Gen
      rates :audio
      attributes channel_count: 1

      inputs trigger: 0, dur: 1, sndbuf: nil, playback_rate: 1, pos: 0,
             interp: 2, pan: 0, envbufnum: -1, max_grains: 512
    end
  end
end
