module Scruby
  module Ugen
    class WrapIndex < Base
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
