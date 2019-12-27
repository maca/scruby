module Scruby
  module Ugen
    class SyncSaw < Base
      rates :control, :audio
      inputs sync_freq: 440, saw_freq: 440
    end
  end
end
