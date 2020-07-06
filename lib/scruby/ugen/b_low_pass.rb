module Scruby
  module Ugen
    class BLowPass < Gen
      rates :audio
      inputs input: nil, freq: 1200, rq: 1
    end
  end
end
