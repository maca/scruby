module Scruby
  module Ugen
    class COsc < Gen
      rates :control, :audio
      inputs bufnum: nil, freq: 440, beats: 0.5
    end
  end
end
