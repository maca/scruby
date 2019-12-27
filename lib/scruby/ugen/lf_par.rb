module Scruby
  module Ugen
    class LFPar < Base
      rates :control, :audio
      inputs freq: 440, iphase: 0
    end
  end
end
