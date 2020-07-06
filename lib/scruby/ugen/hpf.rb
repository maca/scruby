module Scruby
  module Ugen
    class HPF < Gen
      rates :control, :audio
      inputs input: 0, freq: 440
    end
  end
end
