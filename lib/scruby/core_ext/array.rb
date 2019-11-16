class Array
  # collect with index
  def collect_with_index
    zip( (0...size).map ).collect{ |element, index| yield element, index }
  end

  def wrap_to(size)
    return self if size == self.size
    dup.wrap_to! size
  end

  def wrap_to!(size)
    return nil if size == self.size
    original_size = self.size
    size.times { |i| self[ i ] = self[ i % original_size ] }
    self
  end

  def wrap_and_zip(*args)
    max  = args.map{ |a| instance_of?(Array) ? a.size : 0 }.max.max( size )
    args = args.collect{ |a| a.to_array.wrap_to( max ) }
    wrap_to( max ).zip( *args )
  end

  # Returns self
  def to_array; self; end

  def encode_floats #:nodoc:
    [size].pack("n") + pack("g*") # TODO: Deprecate
  end

  def peel!
    replace first if first.is_a? Array if size == 1
  end

  def peel
    dup.peel! || self
  end

  private

  def collect_constants #:nodoc:
    collect{ |e| e.send( :collect_constants )  }
  end
end
