module Scruby
  module Ugen
    class Ramp < Gen
      rates :control, :audio
      inputs input: 0, lag_time: 0.1
    end
  end
end
