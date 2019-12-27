module Scruby
  module Ugen
    class PeakFollower < Base
      rates :control, :audio
      inputs input: 0, decay: 0.999
    end
  end
end
