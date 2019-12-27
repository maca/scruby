module Scruby
  module Ugen
    class Demand < Base
      rates :control, :audio
      inputs trig: nil, reset: nil, demand_u_gens: nil
    end
  end
end
