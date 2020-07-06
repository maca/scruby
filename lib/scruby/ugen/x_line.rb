module Scruby
  module Ugen
    class XLine < Gen
      rates :control, :audio
      inputs start: 1, finish: 2, dur: 1, done_action: 0
    end
  end
end
