module Scruby
  module Ugen
    class DelTapRd < Gen
      rates :control, :audio
      inputs buffer: nil, phase: nil, del_time: nil, interp: 1
    end
  end
end
