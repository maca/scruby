module Scruby
  module Ugen
    class Convolution < Base
      rates :audio
      inputs input: nil, kernel: nil, framesize: 512
    end
  end
end
