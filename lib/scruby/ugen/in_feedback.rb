module Scruby
  module Ugen
    class InFeedback < Base
      rates :audio
      inputs bus: 0, num_channels: 1
    end
  end
end
