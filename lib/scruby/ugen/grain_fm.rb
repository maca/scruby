module Scruby
  module Ugen
    class GrainFM < Base
      rates :audio
      inputs num_channels: 1, trigger: 0, dur: 1, carfreq: 440,
             modfreq: 200, index: 1, pan: 0, envbufnum: -1,
             max_grains: 512
    end
  end
end
