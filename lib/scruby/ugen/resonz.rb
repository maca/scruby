module Scruby
  module Ugen
    class Resonz < Base
      rates :control, :audio
      inputs input: 0, freq: 440, bwr: 1
    end
  end
end
