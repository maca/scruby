module Scruby
  module Ugen
    class VarSaw < Base
      rates :control, :audio
      inputs freq: 440, iphase: 0, width: 0.5
    end
  end
end
