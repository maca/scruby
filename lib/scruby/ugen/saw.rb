module Scruby
  module Ugen
    class Saw < Base
      rates :control, :audio
      inputs freq: 440
    end
  end
end
