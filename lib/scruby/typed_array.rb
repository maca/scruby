class TypedArray < Array
  
  attr_reader :type
  
  def initialize( type, elements = [] )
    @type = type.instance_of?(Class) ? type : type.class
    check_array_passed( elements )
    check_types_for_array( elements )
    super( elements )
  end
  
  alias :old_plus :+
  def +( array )
    TypedArray.new( @type, self.old_plus( array ) )
  end
  
  def concat( array )
    check_array_passed( array )
    check_types_for_array( array )
    super
  end
  
  def <<(e)
    check_type_for_obj(e)
    super
  end
  
  def []=(index, e)
    check_type_for_obj(e)
    super
  end
  
  def push(e)
    check_type_for_obj(e)
    super
  end
  
  def flatten
    self
  end
  
  def compact
    self
  end
  
  def flatten!
  end

  def compact!
  end
  
  def check_array_passed(obj)
    raise TypeError.new( "#{obj} is not Array" ) unless obj.instance_of?(Array)
  end
  
  def check_types_for_array( array ) #:nodoc:
    raise TypeError.new("All elements of #{array} should be instance of #{@type}") unless array.reject{ |e| e.instance_of?(@type) }.empty?
  end
  
  def check_type_for_obj( obj ) #:nodoc:
    raise TypeError.new("#{obj} is not instance of #{@type}") unless obj.instance_of?(@type)
  end
  
end