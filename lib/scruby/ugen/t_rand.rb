module Scruby
  module Ugen
    class TRand < Gen
      rates :control, :audio
      inputs lo: 0, hi: 1, trig: 0
    end
  end
end
