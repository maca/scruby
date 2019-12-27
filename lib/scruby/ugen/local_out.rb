module Scruby
  module Ugen
    class LocalOut < Base
      rates :control, :audio
      inputs channels_array: nil
    end
  end
end
