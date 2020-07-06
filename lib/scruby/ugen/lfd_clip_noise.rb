module Scruby
  module Ugen
    class LFDClipNoise < Gen
      rates :control, :audio
      inputs freq: 500
    end
  end
end
