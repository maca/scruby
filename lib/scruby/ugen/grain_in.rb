module Scruby
  module Ugen
    class GrainIn < Base
      rates :audio
      inputs num_channels: 1, trigger: 0, dur: 1, input: nil, pan: 0,
             envbufnum: -1, max_grains: 512
    end
  end
end
