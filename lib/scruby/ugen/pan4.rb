module Scruby
  module Ugen
    class Pan4 < Gen
      rates :control, :audio
      inputs input: nil, xpos: 0, ypos: 0, level: 1
    end
  end
end
