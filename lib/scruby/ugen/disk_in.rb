module Scruby
  module Ugen
    class DiskIn < Base
      rates :audio
      attributes channel_count: 1

      inputs bufnum: nil, loop: 0
    end
  end
end
