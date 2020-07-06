module Scruby
  module Ugen
    class GrainSin < Gen
      rates :audio
      attributes channel_count: 1

      inputs trigger: 0, dur: 1, freq: 440, pan: 0, envbufnum: -1,
             max_grains: 512
    end
  end
end
