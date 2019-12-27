module Scruby
  module Ugen
    class OneZero < Base
      rates :control, :audio
      inputs input: 0, coef: 0.5
    end
  end
end
