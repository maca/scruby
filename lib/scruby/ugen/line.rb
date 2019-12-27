module Scruby
  module Ugen
    class Line < Base
      rates :control, :audio
      inputs start: 0, finish: 1, dur: 1, done_action: 0
    end
  end
end
