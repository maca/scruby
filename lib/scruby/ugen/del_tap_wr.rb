module Scruby
  module Ugen
    class DelTapWr < Gen
      rates :control, :audio
      inputs buffer: nil, input: nil
    end
  end
end
