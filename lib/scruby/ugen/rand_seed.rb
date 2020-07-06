module Scruby
  module Ugen
    class RandSeed < Gen
      rates :control, :audio, :scalar
      inputs trig: 0, seed: 56_789
    end
  end
end
