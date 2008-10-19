require File.join(File.expand_path(File.dirname(__FILE__)),"helper")

require "#{LIB_DIR}/audio/ugens/ugen_operations"
require "#{LIB_DIR}/extensions"
require "#{LIB_DIR}/audio/synthdef" 
# require "#{LIB_DIR}/control_name" 



include Scruby
include Audio

class ControlName
  def self.new( *args )
    args.flatten
  end
end


describe SynthDef, 'instantiation' do
  
  describe 'initialize' do
    before do
    @sdef = SynthDef.new( :name )
    @sdef.stub!( :collect_controls )
  end

    it "should instantiate" do
    @sdef.should_not be_nil
    @sdef.should be_instance_of( SynthDef )
  end
  
    it "should have attributes" do
    @sdef.should respond_to( :name= )
    @sdef.should respond_to( :children= )
    @sdef.should respond_to( :constants= )
    @sdef.should respond_to( :control_names= )

    @sdef.should respond_to( :name )
    @sdef.should respond_to( :children )
    @sdef.should respond_to( :constants )
    @sdef.should respond_to( :control_names )
  end
  
    it "should accept name and set it as an attribute as string" do
    @sdef.name.should eql( 'name' )
  end

    it "should initialize with an empty array for children" do
    @sdef.children.should eql( [] )
  end
  end
  
  describe "options" do
    before do
      @options = mock( Hash )
    end
  
    it "should accept options" do
      sdef = SynthDef.new( :hola, :values => [] ){}
    end
    
    it "should use options" do
      @options.should_receive(:delete).with( :values )
      @options.should_receive(:delete).with( :rates  )
      
      sdef = SynthDef.new( :hola, @options ){}
    end
    
    it "should set default values if not provided" 
    it "should accept a graph function"
    
  end
  
  describe 'collecting controls' do
    before do
      @sdef     = SynthDef.new( :name ){}
      @function = mock( "grap_function", :argument_names => [:arg1, :arg2, :arg3] )
    end
    
    it do
      @sdef.should respond_to(:collect_controls)
    end
    
    it "should get the argument names for the provided function" do
      @function.should_receive( :argument_names ).and_return( [] )
      @sdef.collect_controls( @function, [], [] )
    end
    
    it "should return empty array if the names are empty" do
      @function.should_receive( :argument_names ).and_return( [] )
      @sdef.collect_controls( @function, [], [] ).should eql([])
    end
    
    it "should not return empty array if the names are not empty" do
      @sdef.collect_controls( @function, [], [] ).should_not eql([])
    end
    
    it "should instantiate and return a ControlName for each function name" do
      c_name = mock( :control_name )
      ControlName.should_receive( :new ).at_most(3).times.and_return( c_name )
      control_names = @sdef.collect_controls( @function, [1,2,3] )
      control_names.size.should eql(3)
      control_names.collect { |e| e.should == c_name }
    end
    
    it "should pass the argument value, the argument index and the rate(if provided) to the ControlName at instantiation" do
      @sdef.collect_controls( @function, [:a,:b,:c] ).should eql( [[:arg1, :a, nil, 0], [:arg2, :b, nil, 1], [:arg3, :c, nil, 2]])
      @sdef.collect_controls( @function, [:a,:b,:c], [:ir, :tr, :ir] ).should eql( [[:arg1, :a, :ir, 0], [:arg2, :b, :tr, 1], [:arg3, :c, :ir, 2]])
    end
    
    it "should not return more elements than the function argument number" do
      c_name = mock( :control_name )
      ControlName.should_receive( :new ).at_most(3).times.and_return( c_name )
      @sdef.collect_controls( @function, [:a, :b, :c, :d, :e] ).should have( 3 ).elements
    end
  end

  
end


