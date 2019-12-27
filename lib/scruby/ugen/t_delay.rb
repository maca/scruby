module Scruby
  module Ugen
    class TDelay < Base
      rates :control, :audio
      inputs input: 0, dur: 0.1
    end
  end
end
