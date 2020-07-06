module Scruby
  module Ugen
    class BPeakEQ < Gen
      rates :audio
      inputs input: nil, freq: 1200, rq: 1, db: 0
    end
  end
end
