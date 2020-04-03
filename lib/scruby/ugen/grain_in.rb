module Scruby
  module Ugen
    class GrainIn < Base
      rates :audio
      attributes channel_count: 1

      inputs trigger: 0, dur: 1, input: nil, pan: 0, envbufnum: -1,
             max_grains: 512
    end
  end
end
