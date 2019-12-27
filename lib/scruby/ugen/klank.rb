module Scruby
  module Ugen
    class Klank < Base
      rates :audio
      inputs specifications_array_ref: nil, input: nil, freqscale: 1, freqoffset: 0, decayscale: 1
    end
  end
end
