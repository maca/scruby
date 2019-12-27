module Scruby
  module Ugen
    class Slew < Base
      rates :control, :audio
      inputs input: 0, up: 1, dn: 1
    end
  end
end
