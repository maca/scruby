module Scruby
  module Ugen
    class Compander < Base
      rates :audio
      inputs input: 0, control: 0, thresh: 0.5, slope_below: 1, slope_above: 1, clamp_time: 0.01, relax_time: 0.1
    end
  end
end
