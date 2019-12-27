module Scruby
  module Ugen
    class PanB2 < Base
      rates :control, :audio
      inputs input: nil, azimuth: 0, gain: 1
    end
  end
end
