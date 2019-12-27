module Scruby
  module Ugen
    class LFTri < Base
      rates :control, :audio
      inputs freq: 440, iphase: 0
    end
  end
end
