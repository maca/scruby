module Scruby
  module Ugen
    class BLowShelf < Gen
      rates :audio
      inputs input: nil, freq: 1200, rs: 1, db: 0
    end
  end
end
