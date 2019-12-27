module Scruby
  module Ugen
    class Impulse < Base
      rates :control, :audio
      inputs freq: 440, phase: 0
    end
  end
end
