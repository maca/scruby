module Scruby
  module Ugen
    class MantissaMask < Gen
      rates :control, :audio
      inputs input: 0, bits: 3
    end
  end
end
