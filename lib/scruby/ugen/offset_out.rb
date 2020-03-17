module Scruby
  module Ugen
    class OffsetOut < Base
      include AbstractOut

      rates :control, :audio
    end
  end
end
