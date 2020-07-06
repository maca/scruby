module Scruby
  module Ugen
    class Latch < Gen
      rates :control, :audio
      inputs input: 0, trig: 0
    end
  end
end
