module Scruby
  module Ugen
    class LFNoise1 < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
