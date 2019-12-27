module Scruby
  module Ugen
    class StereoConvolution2L < Base
      rates :audio
      inputs input: nil, kernel_l: nil, kernel_r: nil, trigger: 0, framesize: 2048, crossfade: 1
    end
  end
end
