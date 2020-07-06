module Scruby
  module Ugen
    class Formlet < Gen
      rates :control, :audio
      inputs input: 0, freq: 440, attacktime: 1, decaytime: 1
    end
  end
end
