module Scruby
  module Ugen
    class LeakDC < Gen
      rates :control, :audio
      inputs input: 0, coef: { control: 0.9, audio: 0.995 }
    end
  end
end
