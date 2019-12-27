module Scruby
  module Ugen
    class FreeVerb < Base
      rates :audio
      inputs input: nil, mix: 0.33, room: 0.5, damp: 0.5
    end
  end
end
