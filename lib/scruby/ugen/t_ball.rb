module Scruby
  module Ugen
    class TBall < Gen
      rates :control, :audio
      inputs input: 0, g: 10, damp: 0, friction: 0.01
    end
  end
end
