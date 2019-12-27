module Scruby
  module Ugen
    class CoinGate < Base
      rates :control, :audio
      inputs prob: nil, input: nil
    end
  end
end
