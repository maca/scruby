module Scruby
  module Ugen
    class BufChannels < Gen
      rates :control, :scalar
      inputs bufnum: nil
    end
  end
end
