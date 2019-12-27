module Scruby
  module Ugen
    class StandardN < Base
      rates :audio
      inputs freq: 22_050, k: 1, xi: 0.5, yi: 0
    end
  end
end
