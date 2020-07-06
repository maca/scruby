module Scruby
  module Ugen
    class LFSaw < Gen
      rates :control, :audio
      inputs freq: 440, iphase: 0
    end
  end
end
