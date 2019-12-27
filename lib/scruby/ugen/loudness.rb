module Scruby
  module Ugen
    class Loudness < Base
      rates :control
      inputs chain: nil, smask: 0.25, tmask: 1
    end
  end
end
