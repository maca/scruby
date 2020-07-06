module Scruby
  module Ugen
    class LFClipNoise < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
