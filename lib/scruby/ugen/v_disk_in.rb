module Scruby
  module Ugen
    class VDiskIn < Base
      rates :audio
      attributes channel_count: 1

      inputs bufnum: nil, playback_rate: 1, loop: 0, send_id: 0
    end
  end
end
