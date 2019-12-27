module Scruby
  module Ugen
    class LFDClipNoise < Base
      rates :control, :audio
      inputs freq: 500
    end
  end
end
