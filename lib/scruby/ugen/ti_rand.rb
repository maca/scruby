module Scruby
  module Ugen
    class TIRand < Gen
      rates :control, :audio
      inputs lo: 0, hi: 127, trig: 0
    end
  end
end
