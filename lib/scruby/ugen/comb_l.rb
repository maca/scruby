module Scruby
  module Ugen
    class CombL < Gen
      rates :control, :audio
      inputs input: 0, maxdelaytime: 0.2, delaytime: 0.2, decaytime: 1
    end
  end
end
