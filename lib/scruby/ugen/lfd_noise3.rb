module Scruby
  module Ugen
    class LFDNoise3 < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
