module Scruby
  module Ugen
    class SinOsc < Base
      rates :control, :audio
      inputs freq: 440, phase: 0
    end
  end
end
