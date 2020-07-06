module Scruby
  module Ugen
    class Convolution2 < Gen
      rates :audio
      inputs input: nil, kernel: nil, trigger: 0, framesize: 2048
    end
  end
end
