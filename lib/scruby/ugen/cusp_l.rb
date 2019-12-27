module Scruby
  module Ugen
    class CuspL < Base
      rates :audio
      inputs freq: 22_050, a: 1, b: 1.9, xi: 0
    end
  end
end
