module Scruby
  module Ugen
    class PVJensenAndersen < Base
      rates :audio
      inputs buffer: nil, propsc: 0.25, prophfe: 0.25, prophfc: 0.25, propsf: 0.25, threshold: 1, waittime: 0.04
    end
  end
end
