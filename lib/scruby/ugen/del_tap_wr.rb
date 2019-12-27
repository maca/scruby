module Scruby
  module Ugen
    class DelTapWr < Base
      rates :control, :audio
      inputs buffer: nil, input: nil
    end
  end
end
