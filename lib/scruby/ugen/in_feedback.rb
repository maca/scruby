module Scruby
  module Ugen
    class InFeedback < Base
      rates :audio
      attributes channel_count: 1

      inputs bus: 0
    end
  end
end
