module Scruby
  module Ugen
    class DiskIn < Base
      rates :audio
      inputs num_channels: nil, bufnum: nil, loop: 0
    end
  end
end
