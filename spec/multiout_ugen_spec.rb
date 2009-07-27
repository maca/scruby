require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen" 
require "scruby/ugens/ugen_operations" 
require "scruby/ugens/multi_out_ugens"

include Scruby
include Ugens

describe MultiOutUgen do
  before do
    sdef = mock( 'sdef', :children => [] )
    Ugen.should_receive( :synthdef ).and_return( sdef )
    @proxies = MultiOutUgen.new( :audio, 1, 2, 3 )
    @multi   = sdef.children.first
  end

  it "should return an array of channels" do
    @proxies.should be_instance_of( Array )
    @proxies.should == [1,2,3]
  end

  it "should be instace of Control" do
    @multi.should be_instance_of( MultiOutUgen )
  end

  it do
    @multi.rate.should == :audio
  end

  it do
    @multi.channels.should == [1,2,3]
  end
  
  it do
    @multi.inputs.should == []
  end
end

describe Control do
  before do
    sdef = mock( 'SynthDef', :children => [] )
    Ugen.stub!( :synthdef ).and_return( sdef )

    @proxy = mock(OutputProxy, :instance_of_proxy? => true)
    OutputProxy.stub!( :new ).and_return( @proxy )

    @names = Array.new( rand(7) + 3 ) do |i|
      ControlName.new "control_#{i}", 1, :control, i
    end
    
    @proxies = Control.new( :audio, *@names )
    @control = sdef.children.first
  end

  it "should return an array of proxies" do
    @proxies.should be_instance_of( Array )
    @proxies.should have( @names.size ).proxies
  end

  it "should set channels" do
    @control.should be_instance_of( Control )
    @control.channels.should == @names.map{ @proxy }
  end

  it "should be added to synthdef" do
    Ugen.should_receive( :synthdef )
    Control.new( :audio, [])
  end
  
  it "should instantiate with #and_proxies_from" do
    Control.should_receive(:new).with( :control, *@names )
    Control.and_proxies_from( @names )
  end
  
  it "should have index" do
    @control.index.should == 0
  end
  
end

describe OutputProxy do
  
  before do
    @sdef = mock( 'sdef', :children => [] )
    Ugen.stub!( :synthdef ).and_return( @sdef )
    @name  = ControlName.new( "control", 1, :control, 0)
    @names = [@name]
    @output_index = 1
  end
  
  it "should receive index from control" do
    Control.and_proxies_from( @names ).first.index.should == 0
    @sdef.children.first.index.should == 0
  end
  
  it "should have empty inputs" do
    OutputProxy.new( :audio, @name, @output_index, @name ).inputs.should == []
  end
  
  it "should not be added to synthdef" do
    Ugen.should_not_receive( :synthdef )
    OutputProxy.new( :audio, @name, @output_index, @name )
  end
end


