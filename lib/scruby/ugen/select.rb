module Scruby
  module Ugen
    class Select < Base
      rates :control, :audio
      inputs which: nil, array: nil
    end
  end
end
