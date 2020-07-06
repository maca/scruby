module Scruby
  module Ugen
    class MouseY < Gen
      rates :control
      inputs minval: 0, maxval: 1, warp: 0, lag: 0.2
    end
  end
end
