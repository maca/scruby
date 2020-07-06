module Scruby
  module Ugen
    class VOsc < Gen
      rates :control, :audio
      inputs bufpos: nil, freq: 440, phase: 0
    end
  end
end
