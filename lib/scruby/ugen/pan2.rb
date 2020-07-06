module Scruby
  module Ugen
    class Pan2 < Gen
      rates :control, :audio
      inputs input: nil, pos: 0, level: 1
    end
  end
end
