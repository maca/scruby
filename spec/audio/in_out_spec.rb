require File.join( File.expand_path(File.dirname(__FILE__)),"../helper")

require "#{SCRUBY_DIR}/audio/ugens/ugen_operations"
require "#{SCRUBY_DIR}/extensions"
require "#{SCRUBY_DIR}/audio/ugens/ugen"
require "#{SCRUBY_DIR}/audio/ugens/multi_out_ugens"
require "#{SCRUBY_DIR}/audio/ugens/in_out"

include Scruby
include Audio
include Ugens

class SinOsc < Ugen
   #not interested in muladd
  def self.ar freq=440.0, phase=0.0
    new :audio, freq, phase
  end
end

describe In, Out, 'instantiation' do
  
  it "should not instantiate with #new" do
    lambda { In.new(:audio, 1, 2) }.should raise_error
    lambda { Out.new(:audio, 1, 2) }.should raise_error
  end
end

describe In do
  
  before do
    @sdef = mock( 'ugen', :children => [] )
    Ugen.should_receive( :synthdef ).at_least( :once ).and_return( @sdef )
    
    @proxy   = mock('output proxy', :valid_ugen_input? => true )
    @proxies = (1..10).map{ @proxy }
    OutputProxy.stub!(:new).and_return( @proxy )
    
    @ar = In.ar( 3 )
  end
  
  it "respond to #kr and #ar "do
    In.should respond_to(:kr)
    In.should respond_to(:ar)
  end
  
  it "should spec #ar" do    
    @ar.should be_instance_of( Array )
    @ar.should have(1).proxy
    @ar.first.should == @proxy
  end
  
  it "should have bus as input" do
    @sdef.children.first.inputs.should == [3]
  end
  
  it "should have ten channels" do
    In.ar(0, 10).should == @proxies
  end
  
  it "should describe passing arrays to initialize"

end


describe Out do
  
  before do
    @sdef = mock( 'sdef', :children => [], :constants => [400, 0] )
    Ugen.should_receive( :synthdef ).at_least( :once ).and_return( @sdef )
    
  end               
  
  it "should accept one ugen" do
    @ugen1 = Ugen.new( :audio )
    
    Out.kr( 1, @ugen1 ).should == 0.0
    
    @sdef.children.should have(2).ugens
    
    out = @sdef.children.last
    out.rate.should   == :control
    out.inputs.should == [1, @ugen1]
    out.channels.should == []
  end       
  
  it "should accept several inputs" do
    @ugen1 = Ugen.new( :audio )
    @ugen2 = Ugen.new( :audio )
    @ugen3 = Ugen.new( :audio )
    
    Out.kr( 1, @ugen1, @ugen2, @ugen3 )
    @sdef.children.should have(4).ugens
    
    out = @sdef.children.last
    out.inputs.should == [1, @ugen1, @ugen2, @ugen3]
  end    
  
  it "should accept several inputs from array" do
    @ugen1 = Ugen.new( :audio )
    @ugen2 = Ugen.new( :audio )
    @ugen3 = Ugen.new( :audio )
    
    Out.kr( 1, [@ugen1, @ugen2, @ugen3] )
    @sdef.children.should have(4).ugens
    
    out = @sdef.children.last
    out.inputs.should == [1, @ugen1, @ugen2, @ugen3]
  end

  it "should validate rate"
  it "should substitute zero with silence"
  it "should spec passing array on init"
end






