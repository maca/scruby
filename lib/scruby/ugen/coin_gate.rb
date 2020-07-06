module Scruby
  module Ugen
    class CoinGate < Gen
      rates :control, :audio
      inputs prob: nil, input: nil
    end
  end
end
