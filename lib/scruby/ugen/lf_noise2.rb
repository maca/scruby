module Scruby
  module Ugen
    class LFNoise2 < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
