module Scruby
  module Ugen
    class BufRd < Gen
      rates :control, :audio
      attributes channel_count: 1

      inputs bufnum: 0, phase: 0, loop: 1, interpolation: 2
    end
  end
end
