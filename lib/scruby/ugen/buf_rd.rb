module Scruby
  module Ugen
    class BufRd < Base
      rates :control, :audio
      inputs num_channels: nil, bufnum: 0, phase: 0, loop: 1,
             interpolation: 2
    end
  end
end
