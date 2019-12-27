module Scruby
  module Ugen
    class Balance2 < Base
      rates :control, :audio
      inputs left: nil, right: nil, pos: 0, level: 1
    end
  end
end
