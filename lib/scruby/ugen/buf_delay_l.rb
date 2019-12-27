module Scruby
  module Ugen
    class BufDelayL < Base
      rates :control, :audio
      inputs buf: 0, input: 0, delaytime: 0.2
    end
  end
end
