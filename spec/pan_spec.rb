require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen" 
require "scruby/ugens/ugen_operations" 
require "scruby/ugens/multi_out_ugens"
require "scruby/ugens/ugens" 
require "scruby/ugens/pan"

include Scruby
include Ugens

describe 'Panner' do
  shared_examples_for 'Panner' do
    before do
      @pan      = @class.new :audio, *@params
      @inputs ||= @params
      @instance = @pan.first.source
    end

    it "should instantiate using control rate" do
      @class.should_receive(:new).with(:control, *@params)
      @class.kr *@params
    end

    it "should instantiate using audio rate" do
      @class.should_receive(:new).with(:audio, *@params)
      @class.ar *@params
    end

    it "should return an array of output proxies" do
      @pan.should be_a(Array)
      @pan.should have(@channels).proxies
      @pan.each_with_index do |proxy, i|
        proxy.source.should be_a(@class)
        proxy.should be_a(OutputProxy)
        proxy.output_index.should == i
      end
    end

    it "should set inputs" do
      @instance.inputs.should == @inputs
    end

    it "should just accept audio inputs if rate is audio" do
      lambda { @class.new( :audio, Ugen.new(:control) ) }.should raise_error(ArgumentError)
    end

    it "should accept control rate inputs unless rate is audio" do
      @class.new :control, 1, Ugen.new(:control), Ugen.new(:audio)
    end
  end

  describe Pan2 do
    before do
      @class    = Pan2
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 2
    end

    it_should_behave_like 'Panner'

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 2.0]
    end
  end

  describe LinPan2 do
    before do
      @class    = LinPan2
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 2
    end

    it_should_behave_like 'Panner'

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 2.0]
    end
  end

  describe Pan4 do
    before do
      @class    = Pan4
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, 0.5, 0.5, 1.0
      @channels = 4
    end

    it_should_behave_like 'Panner'

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 0.0, 2.0]
    end
  end

  describe Balance2 do
    before do
      @class    = Balance2
      @ugen     = Ugen.new :audio, 1, 2
      @ugen2    = Ugen.new(:audio, 2, 4)
      @params   = @ugen, @ugen2, 0.5, 1.0
      @channels = 2
    end

    it_should_behave_like 'Panner'

    it "should have keyword args" do
      @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    end
  end

  describe Rotate2 do
    before do
      @class    = Rotate2
      @ugen     = Ugen.new :audio, 1, 2
      @ugen2    = Ugen.new :audio, 2, 4
      @params   = @ugen, @ugen2, 0.5
      @channels = 2
    end

    it_should_behave_like 'Panner'
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe PanB do
    before do
      @class    = PanB
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, 0.5, 0.5, 1.0
      @channels = 4
    end

    it_should_behave_like 'Panner'
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe PanB2 do
    before do
      @class    = PanB2
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 3
    end

    it_should_behave_like 'Panner'
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe BiPanB2 do
    before do
      @class    = BiPanB2
      @ugen2    = Ugen.new(:audio, 2, 4)
      @ugen     = Ugen.new :audio, 1, 2
      @params   = @ugen, @ugen2, 0.5, 0.5
      @channels = 3
    end

    it_should_behave_like 'Panner'
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end
  
  describe DecodeB2, 'five channels' do
    before do
      @class    = DecodeB2
      @params   = 5, 0.5, 0.5, 0.5, 0.5
      @inputs   = 0.5, 0.5, 0.5, 0.5
      @channels = 5
    end
    it_should_behave_like 'Panner'
  end
  
  describe DecodeB2, 'seven channels' do
    before do
      @class    = DecodeB2
      @params   = 7, 0.5, 0.5, 0.5, 0.5
      @inputs   = 0.5, 0.5, 0.5, 0.5
      @channels = 7
    end
    it_should_behave_like 'Panner'
  end

  describe PanAz, 'five channels' do
    before do
      @class    = PanAz
      @ugen     = Ugen.new(:audio, 1, 2)
      @params   = 5, @ugen, 0.5, 0.5, 0.5, 0.5
      @inputs   = @ugen, 0.5, 0.5, 0.5, 0.5
      @channels = 5
    end
    it_should_behave_like 'Panner'
  end
end