module Scruby
  module Ugen
    class Saw < Gen
      rates :control, :audio
      inputs freq: 440
    end
  end
end
