class DelegatorArray < Array

  def method_missing meth, *args, &block
    return self.map! { |item| item.send meth, *args, &block }
  end

  def to_da; self; end
  def to_a;  Array.new self; end

  [:*, :+, :-, :/].each do |meth|
    define_method meth do |args|
      binary_op meth, args
    end
  end

  private
  def binary_op op, inputs
    return method_missing(op, inputs) unless inputs.kind_of? Array

    results = self.class.new
    self.zip(inputs).collect_with_index do |pair, index|
      left, right = pair
      next results.push(right) if index + 1 > self.size
      next results.push(left)  if index + 1 > inputs.size
      results.push left.send(op, right)
    end
    results
  end
end

class Array
  def to_da
    DelegatorArray.new self
  end
end

module Kernel
  def d *args
    args.peel!
    darray = DelegatorArray.new
    darray.push *args
    darray
  end
end