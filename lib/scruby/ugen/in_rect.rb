module Scruby
  module Ugen
    class InRect < Base
      rates :control, :audio
      inputs x: 0, y: 0, rect: nil
    end
  end
end
