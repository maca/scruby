module Scruby
  module Ugen
    class MFCC < Base
      rates :control
      inputs chain: nil, numcoeff: 13
    end
  end
end
