module Scruby
  module Ugen
    class LorenzL < Base
      rates :audio
      inputs freq: 22_050, s: 10, r: 28, b: 2.667, h: 0.05, xi: 0.1, yi: 0, zi: 0
    end
  end
end
