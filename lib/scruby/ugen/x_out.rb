module Scruby
  module Ugen
    class XOut < Base
      rates :control, :audio
      inputs bus: nil, xfade: nil, channels_array: nil
    end
  end
end
