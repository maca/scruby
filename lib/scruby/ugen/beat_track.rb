module Scruby
  module Ugen
    class BeatTrack < Gen
      rates :control
      inputs chain: nil, lock: 0
    end
  end
end
