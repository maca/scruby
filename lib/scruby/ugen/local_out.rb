module Scruby
  module Ugen
    class LocalOut < Base
      include AbstractOut

      rates :control, :audio
      inputs channels_array: nil
    end
  end
end
