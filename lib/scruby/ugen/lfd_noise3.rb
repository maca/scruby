module Scruby
  module Ugen
    class LFDNoise3 < Base
      rates :control, :audio
      inputs freq: 500
    end
  end
end
