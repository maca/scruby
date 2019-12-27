module Scruby
  module Ugen
    class BeatTrack < Base
      rates :control
      inputs chain: nil, lock: 0
    end
  end
end
