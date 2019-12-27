module Scruby
  module Ugen
    class Decay2 < Base
      rates :control, :audio
      inputs input: 0, attack_time: 0.01, decay_time: 1
    end
  end
end
