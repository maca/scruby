module Scruby
  module Ugen
    class BufCombC < Gen
      rates :audio
      inputs buf: 0, input: 0, delaytime: 0.2, decaytime: 1
    end
  end
end
