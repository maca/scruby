module Scruby
  module Ugen
    class Warp1 < Base
      rates :audio
      inputs num_channels: 1, bufnum: 0, pointer: 0, freq_scale: 1,
             window_size: 0.2, envbufnum: -1, overlaps: 8,
             window_rand_ratio: 0, interp: 1
    end
  end
end
