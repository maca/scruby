module Scruby
  module Ugen
    class RandSeed < Base
      rates :control, :audio, :scalar
      inputs trig: 0, seed: 56_789
    end
  end
end
