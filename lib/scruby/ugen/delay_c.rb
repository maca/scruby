module Scruby
  module Ugen
    class DelayC < Gen
      rates :control, :audio
      inputs input: 0, maxdelaytime: 0.2, delaytime: 0.2
    end
  end
end
