module Scruby
  module Ugen
    class Convolution3 < Gen
      rates :control, :audio
      inputs input: nil, kernel: nil, trigger: 0, framesize: 2048
    end
  end
end
