module Scruby
  module Ugen
    class SinOscFB < Base
      rates :control, :audio
      inputs freq: 440, feedback: 0
    end
  end
end
