module Scruby
  module Ugen
    class BBandStop < Base
      rates :audio
      inputs input: nil, freq: 1200, bw: 1
    end
  end
end
