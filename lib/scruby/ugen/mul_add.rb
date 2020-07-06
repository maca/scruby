module Scruby
  module Ugen
    class MulAdd < Gen
      rates :control, :audio
      inputs input: nil, mul: 1, add: 0
    end
  end
end
