module Scruby
  module Ugen
    class MantissaMask < Base
      rates :control, :audio
      inputs input: 0, bits: 3
    end
  end
end
