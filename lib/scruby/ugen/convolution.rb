module Scruby
  module Ugen
    class Convolution < Gen
      rates :audio
      inputs input: nil, kernel: nil, framesize: 512
    end
  end
end
