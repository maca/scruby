module Scruby
  module Ugen
    class Osc < Base
      rates :control, :audio
      inputs bufnum: nil, freq: 440, phase: 0
    end
  end
end
