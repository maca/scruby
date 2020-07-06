module Scruby
  module Ugen
    class WrapIndex < Gen
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
