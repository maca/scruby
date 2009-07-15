require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require "scruby/audio/control_name"
require "scruby/audio/env"
require "scruby/audio/ugens/ugen" 
require "scruby/audio/ugens/ugen_operations" 
require "scruby/extensions"
require "scruby/audio/ugens/multi_out_ugens"

include Scruby
include Audio
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
    sdef = mock( 'sdef', :children => [] )
    Ugen.stub!( :synthdef ).and_return( sdef )

    @proxy = mock('proxy', :instance_of_proxy? => true)
    OutputProxy.stub!( :new ).and_return( @proxy )

    @names = Array.new( rand(7) + 3 ){ |i| mock 'name', :rate => :audio  }
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
    Control.should_receive(:new).with( :audio, *@names )
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
    
    @source = mock('source', :index => 0 )
    @name   = mock('control name' )
    @output_index = mock('output_idex' )
    
    @names = [mock('name', :rate => :audio )]
    
  end
  
  it "should receive index from control" do
    Control.and_proxies_from( @names ).first.index.should == 0
    @sdef.children.first.index.should == 0
  end
  
  it "should have empty inputs" do
    OutputProxy.new( :audio, @source, @output_index, @name ).inputs.should == []
  end
  
  
  it "should not be added to synthdef" do
    Ugen.should_not_receive( :synthdef )
    OutputProxy.new( :audio, @source, @output_index, @name )
  end
  
end


