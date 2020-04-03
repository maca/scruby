module Scruby
  module Ugen
    class LagIn < Base
      rates :control
      attributes channel_count: 1

      inputs bus: 0, lag: 0.1
    end
  end
end
