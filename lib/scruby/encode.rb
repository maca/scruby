module Scruby
  module Encode
    module_function

    def encode_int8(num)
      encode_int8_array [ num & 255 ]
    end

    def encode_int16(num)
      encode_int16_array [ num ]
    end

    def encode_int32(num)
      encode_int32_array [ num ]
    end

    def encode_floats_array(array)
      [ array.size ].pack("N") + array.pack("g*")
    end

    def encode_string(string)
      "#{encode_int8(string.size)}#{string[0..255]}"
      encode_int8(string.size) + string[0..255]
    end

    def encode_int8_array(ary)
      ary.pack("C*")
    end

    def encode_int16_array(ary)
      ary.pack("n*")
    end

    def encode_int32_array(ary)
      ary.pack("N*")
    end

    def string_to_hex(string)
      string.unpack("C*").map { |num| num.to_s(16).rjust(2, "0") }
    end
  end
end
