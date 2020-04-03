module Scruby
  module Ugen
    class LocalIn < Base
      rates :control, :audio
      attributes channel_count: 1

      inputs default: 0
    end
  end
end
