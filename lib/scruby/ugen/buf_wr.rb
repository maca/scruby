module Scruby
  module Ugen
    class BufWr < Gen
      rates :control, :audio
      inputs input_array: nil, bufnum: 0, phase: 0, loop: 1
    end
  end
end
