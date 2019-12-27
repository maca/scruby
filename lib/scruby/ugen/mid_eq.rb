module Scruby
  module Ugen
    class MidEQ < Base
      rates :control, :audio
      inputs input: 0, freq: 440, rq: 1, db: 0
    end
  end
end
