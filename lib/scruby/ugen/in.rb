module Scruby
  module Ugen
    class In < Base
      rates :control, :audio
      attributes channel_count: 1

      inputs bus: 0
    end
  end
end
