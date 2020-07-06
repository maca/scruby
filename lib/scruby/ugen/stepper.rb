module Scruby
  module Ugen
    class Stepper < Gen
      rates :control, :audio
      inputs trig: 0, reset: 0, min: 0, max: 7, step: 1, resetval: nil
    end
  end
end
