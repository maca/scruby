module Scruby
  module Ugen
    class BBandPass < Gen
      rates :audio
      inputs input: nil, freq: 1200, bw: 1
    end
  end
end
