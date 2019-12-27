module Scruby
  module Ugen
    class VOsc3 < Base
      rates :control, :audio
      inputs bufpos: nil, freq1: 110, freq2: 220, freq3: 440
    end
  end
end
