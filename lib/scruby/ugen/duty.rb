module Scruby
  module Ugen
    class Duty < Gen
      rates :control, :audio
      inputs dur: 1, reset: 0, level: 1, done_action: 0
    end
  end
end
