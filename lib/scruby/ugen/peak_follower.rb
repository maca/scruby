module Scruby
  module Ugen
    class PeakFollower < Gen
      rates :control, :audio
      inputs input: 0, decay: 0.999
    end
  end
end
