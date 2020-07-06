module Scruby
  module Ugen
    class Demand < Gen
      rates :control, :audio
      inputs trig: nil, reset: nil, demand_u_gens: nil
    end
  end
end
