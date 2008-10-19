require File.join(File.expand_path(File.dirname(__FILE__)),"helper")
require 'yaml'

require "#{LIB_DIR}/audio/ugens/ugen_operations" 
require "#{LIB_DIR}/extensions"

include Scruby
include Audio
include Ugens

Klass = nil

describe UgenOperations, 'loading module' do
  
  before :all do
    class BinaryOpUgen
      attr_accessor :inputs, :operator
      def initialize(op, *args)
        @operator = op
        @inputs   = args
      end
    end
    @ugen = mock( 'ugen', :ugen? => true)
  end
  
  before do
    Object.send(:remove_const, 'Klass') 
    class Klass; end
  end
  
  describe 'module inclusion' do
    
    it "should receive #included" do
      UgenOperations.should_receive( :included ).with( Klass )
      Klass.send( :include, UgenOperations )
    end
    
    it "should include module" do
      Klass.send( :include, UgenOperations )
      Klass.included_modules.should include( UgenOperations )
    end
    
    it "should include InstanceMethods" do
      Klass.send( :include, UgenOperations )
      Klass.included_modules.should include( UgenOperations::BinaryOperations )
    end
    
    it do
      Klass.send( :include, UgenOperations )
      Klass.new.should respond_to( :+ )
    end
    
    it "should sum" do
      Klass.send( :include, UgenOperations )
      (Klass.new + @ugen).should be_instance_of(BinaryOpUgen)
    end
    
    it do
      Klass.send( :include, UgenOperations )
      lambda{ Klass.new + 1 }.should raise_error(ArgumentError)
    end
    
    it "respond to #ugen_sum (it will override #+ but can't name a method old_+)" do
      Klass.send( :include, UgenOperations )
      Klass.new.should respond_to( :ugen_plus )
    end
    
    it "should call the original #+" do
      Object.send(:remove_const, 'Klass') 
      class Klass; def +( input ); end; end
      Klass.send( :include, UgenOperations )
      (Klass.new + Klass.new).should be_nil
    end
  end
  
  describe Numeric do
    before do
      @ugen = mock( 'ugen', :ugen? => true )
    end

    it do
      1.should respond_to( :ring4 )
      1.should respond_to( :ugen_plus )
    end

    it do
      1.2.should respond_to( :ring4 )
    end

    it "should sum with overriden method #sum" do
      (1 + 1 ).should == 2
    end
    
    it "should return a BinarayOpUgen when adding an Ugen" do
      (1 + @ugen).should be_instance_of( BinaryOpUgen )
    end
    
    it "should set the correct inputs and operator for the binopugen" do
      (1.0 + @ugen).inputs.should == [1.0, @ugen]
      (1 + @ugen).operator.should == :+
    end
  end
  
  describe Array do
    
    before :all do
      Ugen = mock( 'Ugen' )
    end
    
    before do
      Klass.send( :include, UgenOperations )
      @ugen = mock( 'ugen', :ugen? => true )
      @ugen.stub!( :instance_of? ).with( Ugen ).and_return( true )
      @ugen.stub!( :instance_of? ).with( Ugen ).and_return( true )
      @ugen.should be_instance_of( Ugen )
    end

    it do
      [].should respond_to( :ring4 )
      [].should respond_to( :ugen_plus )
    end
    
    it "should sum an ugen" do
      [] + @ugen
    end
    
    it "should sum arrays as expected" do
      ([1,2] + [3]).should == [1,2,3]
    end

    it "should return" do
      BinaryOpUgen.should_receive( :new ).with( :+, [1,2], @ugen )
      ([1, 2] + @ugen)
    end    
  end
  
end


# methods overriden by UgenOperations inclusion: 
# Fixnum#+ Fixnum#gcd Fixnum#/ Fixnum#round Fixnum#lcm Fixnum#div Fixnum#- Fixnum#>= Fixnum#* Fixnum#<= 
# Float#+ Float#/ Float#round Float#div Float#- Float#>= Float#* Float#<= 
# Array#+ Array#- Array#*
# changed max and min to maximum and minimum because the override Array#max and Array#min wich take no args


