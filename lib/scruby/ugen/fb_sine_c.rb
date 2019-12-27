module Scruby
  module Ugen
    class FBSineC < Base
      rates :audio
      inputs freq: 22_050, im: 1, fb: 0.1, a: 1.1, c: 0.5, xi: 0.1, yi: 0.1
    end
  end
end
