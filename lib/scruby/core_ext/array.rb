class Array
  #collect with index
  def collect_with_index
    self.zip( (0...self.size).map ).collect{ |element, index| yield element, index }
  end

  def wrap_to size
    return self if size == self.size
    self.dup.wrap_to! size
  end

  def wrap_to! size
    return nil if size == self.size
    original_size = self.size
    size.times { |i| self[ i ] = self[ i % original_size ] }
    self
  end

  def wrap_and_zip *args
    max  = args.map{ |a| instance_of?(Array) ? a.size : 0 }.max.max( self.size )
    args = args.collect{ |a| a.to_array.wrap_to( max ) }
    self.wrap_to( max ).zip( *args )
  end

  # Returns self
  def to_array; self; end

  def encode_floats #:nodoc:
    [self.size].pack('n') + self.pack('g*') #TODO: Deprecate
  end

  def muladd mul, add #:nodoc:
    self.collect{ |u| MulAdd.new( u, mul, add ) }
  end
  
  def peel!
    self.replace self.first if self.first.kind_of? Array if self.size == 1
  end
  
  def peel
    self.dup.peel! || self
  end
  
  private
  def collect_constants #:nodoc:
    self.collect{ |e| e.send( :collect_constants )  }
  end
end