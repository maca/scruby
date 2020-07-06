module Scruby
  module Ugen
    class Amplitude < Gen
      rates :control, :audio
      inputs input: 0, attack_time: 0.01, release_time: 0.01
    end
  end
end
