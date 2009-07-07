
class Object
  
  # Wraps self int an array, #to_a seems to be deprecated
  def to_array
    [*self]
  end

  # TODO : deprecate
  def ugen?; false; end

  def valid_ugen_input? #:nodoc:
    false
  end
end

class Numeric
  # Rate is :scalar
  def rate; :scalar; end

  # Compares itself with +other+ and returns biggest
  def max( other )
    self > other ? self : other
  end

  # Compares itself with +other+ and returns smallest
  def min( other )
    self < other ? self : other
  end
end

class Numeric
  private
  def collect_constants #:nodoc:
    self
  end  

  def input_specs( synthdef )
    [-1, synthdef.constants.index(self)]
  end
end

class Array

  #collect with index
  def collect_with_index
    indices = (0...self.size).map
    self.zip( indices ).collect{ |element_with_index| yield( element_with_index.first, element_with_index.last )  }
  end

  def wrap_to( size )
    return self if size == self.size
    self.dup.wrap_to!( size )
  end

  def wrap_to!( size )
    return nil if size == self.size
    original_size = self.size
    size.times { |i| self[ i ] = self[ i % original_size ] }
    self
  end

  def wrap_and_zip( *args )
    max  = args.map{ |a| instance_of?(Array) ? a.size : 0 }.max.max( self.size )
    args = args.collect{ |a| a.to_array.wrap_to( max ) }
    self.wrap_to( max ).zip( *args )
  end

  # Returns self
  def to_array; self; end

  def encode_floats #:nodoc:
    [self.size].pack('n') + self.pack('g*')
  end

  def muladd( mul, add ) #:nodoc:
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

class Proc
  # Returns an array of symbols corresponding to the argument names
  def arguments
    case self.arity
    when -1..0 then []
    when 1 then self.to_sexp.assoc( :dasgn_curr )[1].to_array
    else self.to_sexp[2][1][1..-1].collect{ |arg| arg[1]  }
    end
  end
end

class String
  def encode #:nodoc:
    [self.size & 255].pack('C*') + self[0..255]
  end
end


class Symbol
  def to_proc
    proc { |obj, *args| obj.send(self, *args) }
  end
end

# Musical math
class Fixnum  
  def freq
    440 * (2 ** ((self - 69) * 0.083333333333) )
  end
end





