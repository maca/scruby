module Scruby
  module Encode
    def encode_floats_array(array)
      [ array.size ].pack("n") + array.pack("g*")
    end

    def encode_string(string)
      [ string.size & 255 ].pack("C*") + string[0..255]
    end
  end
end
