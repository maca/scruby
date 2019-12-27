module Scruby
  module Ugen
    class IEnvGen < Base
      rates :control, :audio
      inputs envelope: nil, index: nil
    end
  end
end
