module Scruby
  module Ugen
    class Onsets < Base
      rates :control
      inputs chain: nil, threshold: 0.5, odftype: "rcomplex",
             relaxtime: 1, floor: 0.1, mingap: 10, medianspan: 11,
             whtype: 1, rawodf: 0
    end
  end
end
