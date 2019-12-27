module Scruby
  module Ugen
    class LagUD < Base
      rates :control, :audio
      inputs input: 0, lag_time_u: 0.1, lag_time_d: 0.1
    end
  end
end
