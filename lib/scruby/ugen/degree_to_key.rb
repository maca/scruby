module Scruby
  module Ugen
    class DegreeToKey < Base
      rates :control, :audio
      inputs bufnum: nil, input: 0, octave: 12
    end
  end
end
