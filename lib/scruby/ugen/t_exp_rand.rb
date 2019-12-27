module Scruby
  module Ugen
    class TExpRand < Base
      rates :control, :audio
      inputs lo: 0.01, hi: 1, trig: 0
    end
  end
end
