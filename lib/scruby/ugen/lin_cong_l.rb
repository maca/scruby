module Scruby
  module Ugen
    class LinCongL < Base
      rates :audio
      inputs freq: 22_050, a: 1.1, c: 0.13, m: 1, xi: 0
    end
  end
end
