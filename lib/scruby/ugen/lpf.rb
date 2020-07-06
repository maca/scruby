module Scruby
  module Ugen
    class LPF < Gen
      rates :control, :audio
      inputs input: 0, freq: 440
    end
  end
end
