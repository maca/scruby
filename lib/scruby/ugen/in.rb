module Scruby
  module Ugen
    class In < Base
      rates :control, :audio
      inputs bus: 0, num_channels: 1
    end
  end
end
