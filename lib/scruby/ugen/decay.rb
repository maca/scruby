module Scruby
  module Ugen
    class Decay < Base
      rates :control, :audio
      inputs input: 0, decay_time: 1
    end
  end
end
