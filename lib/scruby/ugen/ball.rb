module Scruby
  module Ugen
    class Ball < Base
      rates :control, :audio
      inputs input: 0, g: 1, damp: 0, friction: 0.01
    end
  end
end
