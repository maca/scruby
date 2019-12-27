module Scruby
  module Ugen
    class MoogFF < Base
      rates :control, :audio
      inputs input: nil, freq: 100, gain: 2, reset: 0
    end
  end
end
