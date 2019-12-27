module Scruby
  module Ugen
    class VDiskIn < Base
      rates :audio
      inputs num_channels: nil, bufnum: nil, playback_rate: 1, loop: 0,
             send_id: 0
    end
  end
end
