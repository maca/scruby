class DelegatorArray < Array
  
  def method_undefined meth, args
    return self.class.new( self.map { |item| item.send meth, args } ) unless args.kind_of? Array

    results = self.class.new
    self.zip(args).collect_with_index do |pair, index|
      left, right = pair
      
      next results.push(right) if index + 1 > self.size
      next results.push(left)  if index + 1 > args.size 

      results.push left.send(meth, right)
    end 

    results

  end
  
  [:*, :+, :-, :/].each do |meth|
    define_method meth do |*args|
      method_undefined meth, *args
    end
  end
end

module Kernel
  def d *args
    args.peel!
    carray = DelegatorArray.new
    carray.push *args
    carray
  end
end