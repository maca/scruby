module Scruby
  module Ugen
    class LagIn < Base
      rates :control
      inputs bus: 0, num_channels: 1, lag: 0.1
    end
  end
end
