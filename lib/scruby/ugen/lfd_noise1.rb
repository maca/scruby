module Scruby
  module Ugen
    class LFDNoise1 < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
