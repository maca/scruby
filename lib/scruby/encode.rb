module Scruby
  module Encode
    def encode_int8(num)
      encode_int_array [num & 255 ]
    end

    def encode_int16(num)
      [ num ].pack("n")
    end

    def encode_int32(num)
      [ num ].pack("N")
    end

    def encode_floats_array(array)
      [ array.size ].pack("N") + array.pack("g*")
    end

    def encode_string(string)
      "#{encode_int8(string.size)}#{string[0..255]}"
      encode_int8(string.size) + string[0..255]
    end

    def encode_int_array(ary)
      ary.pack("C*")
    end
  end
end
