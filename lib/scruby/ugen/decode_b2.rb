module Scruby
  module Ugen
    class DecodeB2 < Base
      rates :control, :audio
      inputs num_chans: nil, w: nil, x: nil, y: nil, orientation: 0.5
    end
  end
end
