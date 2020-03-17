module Scruby
  module Ugen
    class PanAz < Base
      rates :control, :audio
      inputs num_chans: nil, input: nil, pos: 0, level: 1, width: 2,
             orientation: 0.5
    end
  end
end
