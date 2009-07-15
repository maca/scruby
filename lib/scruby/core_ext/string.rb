class String
  def encode #:nodoc:
    [self.size & 255].pack('C*') + self[0..255]
  end
end