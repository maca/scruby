module Scruby
  module Ugen
    class LFClipNoise < Base
      rates :control, :audio
      inputs freq: 500
    end
  end
end
