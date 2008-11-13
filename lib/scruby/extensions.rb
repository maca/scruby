
class Object
  def to_array
    [*self]
  end

  def ugen?
    false
  end

  def valid_ugen_input?
    false
  end
end

class Numeric
  def rate
    :scalar
  end

  def max( other )
    self > other ? self : other
  end

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

class Fixnum
  include Scruby::Audio::Ugens::UgenOperations
end

class Float
  include Scruby::Audio::Ugens::UgenOperations
end

class Array
  include Scruby::Audio::Ugens::UgenOperations

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
    max = args.map{ |a| instance_of?(Array) ? a.size : 0 }.max.max( self.size )
    args = args.collect{ |a| a.to_array.wrap_to( max ) }
    self.wrap_to( max ).zip( *args )
  end

  def to_array
    self
  end

  def encode_floats
    [self.size].pack('n') + self.pack('g*')
  end

  def muladd( mul, add )
    self.collect{ |u| MulAdd.new( u, mul, add ) }
  end

  private
  def collect_constants #:nodoc:
    self.collect{ |e| e.send( :collect_constants )  }
  end
end

class Proc
  def argument_names
    case self.arity
    when -1..0: []
    when 1: self.to_sexp.assoc( :dasgn_curr )[1].to_array
    else self.to_sexp[2][1][1..-1].collect{ |arg| arg[1]  }
    end
  end
end

class String
  def encode
    [self.size & 255].pack('C*') + self[0..255]
  end
end

