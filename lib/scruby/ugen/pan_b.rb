module Scruby
  module Ugen
    class PanB < Gen
      rates :control, :audio
      inputs input: nil, azimuth: 0, elevation: 0, gain: 1
    end
  end
end
