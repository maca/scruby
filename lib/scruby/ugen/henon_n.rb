module Scruby
  module Ugen
    class HenonN < Base
      rates :audio
      inputs freq: 22_050, a: 1.4, b: 0.3, x0: 0, x1: 0
    end
  end
end
