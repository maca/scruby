class Numeric
  # Rate is :scalar
  def rate; :scalar; end

  # Compares itself with +other+ and returns biggest
  def max other
    self > other ? self : other
  end

  # Compares itself with +other+ and returns smallest
  def min other
    self < other ? self : other
  end

  private
  #:nodoc:
  def collect_constants
    self
  end

  #:nodoc:
  def input_specs synthdef
    [-1, synthdef.constants.index(self)]
  end
end