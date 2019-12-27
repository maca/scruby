module Scruby
  module Ugen
    class Pan2 < Base
      rates :control, :audio
      inputs input: nil, pos: 0, level: 1
    end
  end
end
