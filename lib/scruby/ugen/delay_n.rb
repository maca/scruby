module Scruby
  module Ugen
    class DelayN < Base
      rates :control, :audio
      inputs input: 0, maxdelaytime: 0.2, delaytime: 0.2
    end
  end
end
