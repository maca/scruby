module Scruby
  module Ugen
    class BufChannels < Base
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
