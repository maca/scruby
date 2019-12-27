module Scruby
  module Ugen
    class BeatTrack2 < Base
      rates :control
      inputs busindex: nil, numfeatures: nil, windowsize: 2, phaseaccuracy: 0.02, lock: 0, weightingscheme: nil
    end
  end
end
