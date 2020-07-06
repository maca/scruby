module Scruby
  module Ugen
    class Pulse < Gen
      rates :control, :audio
      inputs freq: 440, width: 0.5
    end
  end
end
