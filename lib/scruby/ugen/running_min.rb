module Scruby
  module Ugen
    class RunningMin < Base
      rates :control, :audio
      inputs input: 0, trig: 0
    end
  end
end
