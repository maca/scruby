module Scruby
  module Ugen
    class LFSaw < Base
      rates :control, :audio
      inputs freq: 440, iphase: 0
    end
  end
end
