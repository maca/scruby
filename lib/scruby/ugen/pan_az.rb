module Scruby
  module Ugen
    class PanAz < Base
      rates :control, :audio
      attributes channel_count: 1

      inputs input: nil, pos: 0, level: 1, width: 2, orientation: 0.5
    end
  end
end
