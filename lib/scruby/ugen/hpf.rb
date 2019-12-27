module Scruby
  module Ugen
    class HPF < Base
      rates :control, :audio
      inputs input: 0, freq: 440
    end
  end
end
