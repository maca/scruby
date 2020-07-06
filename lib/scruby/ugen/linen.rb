module Scruby
  module Ugen
    class Linen < Gen
      rates :control
      inputs gate: 1, attack_time: 0.01, sus_level: 1, release_time: 1,
             done_action: 0
    end
  end
end
