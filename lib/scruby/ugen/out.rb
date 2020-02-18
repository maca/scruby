module Scruby
  module Ugen
    class Out < Ugen::Base
      include AbstractOut

      rates :control, :audio
      inputs bus: nil, channels_array: nil
    end
  end
end
