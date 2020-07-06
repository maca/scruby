module Scruby
  module Ugen
    class Timer < Gen
      rates :control, :audio
      inputs trig: 0
    end
  end
end
