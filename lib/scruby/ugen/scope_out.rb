module Scruby
  module Ugen
    class ScopeOut < Gen
      rates :control, :audio
      inputs input_array: nil, bufnum: 0
    end
  end
end
