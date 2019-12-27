module Scruby
  module Ugen
    class TwoZero < Base
      rates :control, :audio
      inputs input: 0, freq: 440, radius: 0.8
    end
  end
end
