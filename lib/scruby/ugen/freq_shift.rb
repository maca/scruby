module Scruby
  module Ugen
    class FreqShift < Base
      rates :audio
      inputs input: nil, freq: 0, phase: 0
    end
  end
end
