module Scruby
  module Ugen
    class LFTri < Gen
      rates :control, :audio
      inputs freq: 440, iphase: 0
    end
  end
end
