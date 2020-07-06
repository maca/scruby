module Scruby
  module Ugen
    class Limiter < Gen
      rates :audio
      inputs input: 0, level: 1, dur: 0.01
    end
  end
end
