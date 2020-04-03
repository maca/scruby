module Scruby
  module Ugen
    class DecodeB2 < Base
      rates :control, :audio
      attributes channel_count: 1

      inputs w: nil, x: nil, y: nil, orientation: 0.5
    end
  end
end
