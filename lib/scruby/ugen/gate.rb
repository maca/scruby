module Scruby
  module Ugen
    class Gate < Gen
      rates :control, :audio
      inputs input: 0, trig: 0
    end
  end
end
