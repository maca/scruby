module Scruby
  module Ugen
    class BufRateScale < Gen
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
