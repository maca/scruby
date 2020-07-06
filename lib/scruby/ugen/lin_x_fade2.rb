module Scruby
  module Ugen
    class LinXFade2 < Gen
      rates :control, :audio
      inputs in_a: nil, in_b: 0, pan: 0, level: 1
    end
  end
end
