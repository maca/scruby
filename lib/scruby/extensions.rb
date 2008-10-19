
class Object
  def to_array
    [*self]
  end
  
  def ugen?
    false
  end
end

class Numeric
  def rate
    :scalar
  end
end

class Fixnum
  include Scruby::Audio::UgenOperations
end

class Float
  include Scruby::Audio::UgenOperations
end

class Array
  # include Scruby::Audio::UgenOperations
  
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

  def to_array
    self
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

