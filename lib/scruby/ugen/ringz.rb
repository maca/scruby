module Scruby
  module Ugen
    class Ringz < Base
      rates :control, :audio
      inputs input: 0, freq: 440, decaytime: 1
    end
  end
end
