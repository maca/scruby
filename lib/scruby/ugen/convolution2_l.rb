module Scruby
  module Ugen
    class Convolution2L < Gen
      rates :audio
      inputs input: nil, kernel: nil, trigger: 0, framesize: 2048,
             crossfade: 1
    end
  end
end
