require File.expand_path(File.dirname(__FILE__)) + "/helper"
require 'yaml'

require "scruby/core_ext/delegator_array"
require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen"
require "scruby/ugens/operation_ugens"
require "scruby/ugens/ugen_operations"


include Scruby
include Ugens

class MockUgen < Ugen
  class << self; public :new; end
end

describe UgenOperations do

  before do
    @ugen  = MockUgen.new :audio
    @ugen2 = MockUgen.new :audio
  end

  describe 'binary operations' do
    it "should sum" do
      sum = @ugen + @ugen2
      sum.should be_instance_of(BinaryOpUGen)
    end

    it 'should sum integer' do
      sum = @ugen + 1.0
      sum.should be_instance_of(BinaryOpUGen)
    end

    it "should raise argument error" do
      lambda { @ugen + :hola }.should raise_error(NoMethodError)
    end
  end

  describe 'unary operations' do
    it "should do unary op" do
      op = @ugen.distort
      op.should be_instance_of(UnaryOpUGen)
      op.inputs.should == [@ugen]
    end
  end

  describe Numeric do
    it "do unary operation" do
      1.distort.should == UnaryOpUGen.new(:distort, 1)
    end

    it "should use original +" do
      sum = 1 + 1
      sum.should == 2
    end

    it "should set the correct inputs and operator for the binopugen" do
      sum = 1.0 + @ugen
      sum.should == BinaryOpUGen.new(:+, 1.0, @ugen)
    end

    it "ugen should sum numeric" do
      sum = @ugen + 1
      sum.should == BinaryOpUGen.new(:+, @ugen, 1)
    end

    it 'ugen should sum array' do
      sum = @ugen * d(1,2)
      sum.should == d(BinaryOpUGen.new(:*, @ugen, 1), BinaryOpUGen.new(:*, @ugen, 2))
    end
  end

  describe DelegatorArray do
    before do
      @ugen  = MockUgen.new :audio
    end

    it "do binary operation" do
      d(@ugen).distort.should == d(@ugen.distort)
    end

    it "should do binary operation" do
      op = d(1, 2) * @ugen
      op.should be_a(DelegatorArray)
      op.should == d(BinaryOpUGen.new(:*, 1, @ugen), BinaryOpUGen.new(:*, 2, @ugen))
    end
  end

end


# methods overriden by UgenOperations inclusion:
# Fixnum#+ Fixnum#gcd Fixnum#/ Fixnum#round Fixnum#lcm Fixnum#div Fixnum#- Fixnum#>= Fixnum#* Fixnum#<=
# Float#+ Float#/ Float#round Float#div Float#- Float#>= Float#* Float#<=
# changed max and min to maximum and minimum because the override Array#max and Array#min wich take no args


