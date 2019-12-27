module Scruby
  module Ugen
    class Integrator < Base
      rates :control, :audio
      inputs input: 0, coef: 1
    end
  end
end
