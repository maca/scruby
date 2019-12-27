module Scruby
  module Ugen
    class Gendy3 < Base
      rates :control, :audio
      inputs ampdist: 1, durdist: 1, adparam: 1, ddparam: 1, freq: 440, ampscale: 0.5, durscale: 0.5, init_c_ps: 12, knum: nil
    end
  end
end
