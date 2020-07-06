module Scruby
  module Ugen
    class MouseButton < Gen
      rates :control
      inputs minval: 0, maxval: 1, lag: 0.2
    end
  end
end
