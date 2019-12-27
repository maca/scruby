module Scruby
  module Ugen
    class BiPanB2 < Base
      rates :control, :audio
      inputs in_a: nil, in_b: nil, azimuth: nil, gain: 1
    end
  end
end
