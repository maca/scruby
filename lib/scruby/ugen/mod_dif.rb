module Scruby
  module Ugen
    class ModDif < Base
      rates :control, :audio, :scalar
      inputs x: 0, y: 0, mod: 1
    end
  end
end
