module Scruby
  module Ugen
    class Index < Gen
      rates :control, :audio
      inputs bufnum: nil, input: 0
    end
  end
end
