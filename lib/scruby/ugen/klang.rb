module Scruby
  module Ugen
    class Klang < Gen
      rates :audio
      inputs specifications_array_ref: nil, freqscale: 1, freqoffset: 0
    end
  end
end
