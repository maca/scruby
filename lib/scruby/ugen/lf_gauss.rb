module Scruby
  module Ugen
    class LFGauss < Base
      rates :control, :audio
      inputs duration: 1, width: 0.1, iphase: 0, loop: 1, done_action: 0
    end
  end
end
