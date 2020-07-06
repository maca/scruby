module Scruby
  module Ugen
    class IEnvGen < Gen
      rates :control, :audio
      inputs envelope: nil, index: nil
    end
  end
end
