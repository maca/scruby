module Scruby
  module Ugen
    class MFCC < Gen
      rates :control
      inputs chain: nil, numcoeff: 13
    end
  end
end
