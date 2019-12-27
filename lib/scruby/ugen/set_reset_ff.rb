module Scruby
  module Ugen
    class SetResetFF < Base
      rates :control, :audio
      inputs trig: 0, reset: 0
    end
  end
end
