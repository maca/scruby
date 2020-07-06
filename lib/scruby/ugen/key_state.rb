module Scruby
  module Ugen
    class KeyState < Gen
      rates :control
      inputs keycode: 0, minval: 0, maxval: 1, lag: 0.2
    end
  end
end
