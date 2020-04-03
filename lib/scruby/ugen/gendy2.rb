module Scruby
  module Ugen
    class Gendy2 < Base
      rates :control, :audio
      inputs ampdist: 1, durdist: 1, adparam: 1, ddparam: 1,
             minfreq: { control: 20, audio: 440 },
             maxfreq: { control: 1000, audio: 660 }, ampscale: 0.5,
             durscale: 0.5, init_c_ps: 12, knum: nil, a: 1.17, c: 0.31
    end
  end
end
