module Scruby
  module Ugen
    class TRand < Base
      rates :control, :audio
      inputs lo: 0, hi: 1, trig: 0
    end
  end
end
