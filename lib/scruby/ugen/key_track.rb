module Scruby
  module Ugen
    class KeyTrack < Gen
      rates :control
      inputs chain: nil, keydecay: 2, chromaleak: 0.5
    end
  end
end
