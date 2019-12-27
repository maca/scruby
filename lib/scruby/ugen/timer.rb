module Scruby
  module Ugen
    class Timer < Base
      rates :control, :audio
      inputs trig: 0
    end
  end
end
