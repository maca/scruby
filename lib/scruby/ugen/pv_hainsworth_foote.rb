module Scruby
  module Ugen
    class PVHainsworthFoote < Base
      rates :audio
      inputs buffer: nil, proph: 0, propf: 0, threshold: 1, waittime: 0.04
    end
  end
end
