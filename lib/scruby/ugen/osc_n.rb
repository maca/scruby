module Scruby
  module Ugen
    class OscN < Base
      rates :control, :audio
      inputs bufnum: nil, freq: 440, phase: 0
    end
  end
end
