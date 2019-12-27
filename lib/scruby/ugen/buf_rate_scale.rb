module Scruby
  module Ugen
    class BufRateScale < Base
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
