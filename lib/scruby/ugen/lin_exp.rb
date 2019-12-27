module Scruby
  module Ugen
    class LinExp < Base
      rates :control, :audio
      inputs input: 0, srclo: 0, srchi: 1, dstlo: 1, dsthi: 2
    end
  end
end
