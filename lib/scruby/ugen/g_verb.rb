module Scruby
  module Ugen
    class GVerb < Base
      rates :audio
      inputs input: nil, roomsize: 10, revtime: 3, damping: 0.5, inputbw: 0.5, spread: 15, drylevel: 1, earlyreflevel: 0.7, taillevel: 0.5, maxroomsize: 300
    end
  end
end
