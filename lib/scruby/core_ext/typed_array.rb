
# Typed array is a kind of Array that only accepts elements of a given Class, it will raise a TypeError if an element of
# diferent Class is passed to the operation methods or if an Array containing objects of a diferent class is concatenated.
class TypedArray < Array
  attr_reader :type

  # +Type+ a Class or an instance, on the operation methods it will match the argument against the Class or instance's Class
  def initialize(type, elements = [])
    @type = type.instance_of?(Class) ? type : type.class
    check_array_passed elements
    check_types_for_array elements
    super elements
  end

  # alias :old_plus :+ #:nodoc:
  #
  # def + array
  #   self.class.new @type, self.old_plus( array )
  # end

  def concat(array)
    check_array_passed array
    check_types_for_array array
    super
  end

  def <<(e)
    check_type_for_obj e
    super
  end

  def []=(index, e)
    check_type_for_obj e
    super
  end

  def push(e)
    check_type_for_obj e
    super
  end

  private

  def check_array_passed(obj)
    raise TypeError, "#{obj} is not Array" unless obj.instance_of? Array
  end

  def check_types_for_array(array)
    raise TypeError, "All elements of #{array} should be instance of #{@type}" unless array.reject{ |e| e.instance_of? @type }.empty?
  end

  def check_type_for_obj(obj)
    raise TypeError, "#{obj} is not instance of #{@type}" unless obj.instance_of? @type
  end
end
