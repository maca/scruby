module Scruby
  module Ugen
    class LFDNoise1 < Base
      rates :control, :audio
      inputs freq: 500
    end
  end
end
