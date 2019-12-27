module Scruby
  module Ugen
    class PulseDivider < Base
      rates :control, :audio
      inputs trig: 0, div: 2, start: 0
    end
  end
end
