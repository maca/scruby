module Scruby
  module Ugen
    class Pluck < Base
      rates :audio
      inputs input: 0, trig: 1, maxdelaytime: 0.2, delaytime: 0.2,
             decaytime: 1, coef: 0.5
    end
  end
end
