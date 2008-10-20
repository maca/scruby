require File.join(File.expand_path(File.dirname(__FILE__)),"helper")

require "#{LIB_DIR}/audio/ugens/ugen_operations" 
require "#{LIB_DIR}/audio/ugens/ugen" 
require "#{LIB_DIR}/extensions"
require "#{LIB_DIR}/audio/ugens/multi_out_ugens"

include Scruby
include Audio
include Ugens


describe MultiOutUgen do
  
  it "should respond to channels and outputs" do
    MultiOutUgen.new( :audio, 1 ).should respond_to(:channels)
    MultiOutUgen.new( :audio, 1 ).should respond_to(:outputs)
  end
  
end

describe Control do

  
  before do
    @control = mock('control', :outputs= => nil)
    @names = Array.new( rand(7) + 3 ){ |i| mock('name', :rate => :control)  }
    Ugen.synthdef = nil
    @proxy = mock('proxy', :instance_of_proxy? => true)
    OutputProxy.stub!( :new ).and_return( @proxy )
  end

  it "should instantiate just with rate" do
    Control.new( :audio ).should be_instance_of( Control )
  end
  
  it "should have empty inputs" do
    Control.new( :audio ).inputs.should == []
  end
  
  it "should add to synthdef" do
    sdef = mock('synthdef', :children => [])
    Ugen.synthdef = sdef
    Control.new( :audio )
    sdef.children.should have(1).control
  end
  
  it "should have an empty array for inputs" do
    Control.new( :audio ).inputs.should == []
  end
  
  it do
    Control.should respond_to(:and_proxies_from)
  end
  
  it "should return an array" do
    Control.and_proxies_from( @names ).should be_instance_of(Array)
  end
  
  it "should instantiate a control" do
    Control.should_receive(:new).and_return( @control )
    Control.and_proxies_from( @names )
  end
  
  it "should set rate to the rate of the names of the array" do
    Control.should_receive(:new).with(:control).and_return( @control )
    Control.and_proxies_from( @names )
  end
  
  it "should instantiate an output proxy for each passed name" do
    OutputProxy.should_receive( :new ).exactly( @names.size ).times
    Control.and_proxies_from( @names )
  end
  
  it "should instantiate output proxies with the right attributes" do
    @control = mock('control', :outputs= => nil)
    Control.stub!( :new ).and_return( @control )
    @names.collect_with_index { |n, i| OutputProxy.should_receive(:new).with(@control, n, i) }
    Control.and_proxies_from( @names )
  end
  
  it "should return an array of proxies" do
    Control.and_proxies_from( @names ).each do |proxy|
      proxy.should be_instance_of_proxy
    end
  end
  
  it "should set outputs" do
    @control.should_receive( :outputs= )
    Control.stub!( :new ).and_return( @control )
    Control.and_proxies_from( @names )
  end
end

describe OutputProxy do


end

