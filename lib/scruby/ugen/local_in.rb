module Scruby
  module Ugen
    class LocalIn < Base
      rates :control, :audio
      inputs num_channels: 1, default: 0
    end
  end
end
