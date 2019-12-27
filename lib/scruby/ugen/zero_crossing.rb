module Scruby
  module Ugen
    class ZeroCrossing < Base
      rates :control, :audio
      inputs input: 0
    end
  end
end
