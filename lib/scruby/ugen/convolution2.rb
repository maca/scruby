module Scruby
  module Ugen
    class Convolution2 < Base
      rates :audio
      inputs input: nil, kernel: nil, trigger: 0, framesize: 2048
    end
  end
end
