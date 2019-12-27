module Scruby
  module Ugen
    class VOsc < Base
      rates :control, :audio
      inputs bufpos: nil, freq: 440, phase: 0
    end
  end
end
