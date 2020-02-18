module Scruby
  module Ugen
    class ReplaceOut < Out
      include AbstractOut

      rates :control, :audio
      inputs bus: nil, channels_array: nil
    end
  end
end
