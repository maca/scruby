module Scruby
  module Ugen
    class Blip < Gen
      rates :control, :audio
      inputs freq: 440, numharm: 200
    end
  end
end
