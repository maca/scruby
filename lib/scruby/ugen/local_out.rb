module Scruby
  module Ugen
    class LocalOut < AbstractOut
      rates :control, :audio
      inputs channels_array: nil
    end
  end
end
