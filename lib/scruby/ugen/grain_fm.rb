module Scruby
  module Ugen
    class GrainFM < Gen
      rates :audio
      attributes channel_count: 1

      inputs trigger: 0, dur: 1, carfreq: 440, modfreq: 200, index: 1,
             pan: 0, envbufnum: -1, max_grains: 512
    end
  end
end
