module Scruby
  module Ugen
    class Shaper < Gen
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
