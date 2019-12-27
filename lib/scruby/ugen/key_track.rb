module Scruby
  module Ugen
    class KeyTrack < Base
      rates :control
      inputs chain: nil, keydecay: 2, chromaleak: 0.5
    end
  end
end
