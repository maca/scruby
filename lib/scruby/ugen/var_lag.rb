module Scruby
  module Ugen
    class VarLag < Base
      rates :control, :audio
      inputs input: 0, time: 0.1, curvature: 0, warp: 5, start: nil
    end
  end
end
