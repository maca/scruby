module Scruby
  module Ugen
    class XOut < Base
      include AbstractOut

      rates :control, :audio
      inputs bus: nil, xfade: nil, channels_array: nil
    end
  end
end
