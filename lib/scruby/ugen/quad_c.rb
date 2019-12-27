module Scruby
  module Ugen
    class QuadC < Base
      rates :audio
      inputs freq: 22_050, a: 1, b: -1, c: -0.75, xi: 0
    end
  end
end
