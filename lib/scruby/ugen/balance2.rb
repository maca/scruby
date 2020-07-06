module Scruby
  module Ugen
    class Balance2 < Gen
      rates :control, :audio
      inputs left: nil, right: nil, pos: 0, level: 1
    end
  end
end
