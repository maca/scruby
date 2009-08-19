require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/core_ext/delegator_array"
require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen" 
require "scruby/ugens/ugen_operations" 
require "scruby/ugens/multi_out"
require "scruby/ugens/ugens" 
require "scruby/ugens/panner"

include Scruby
include Ugens

class MockUgen < Ugen
  class << self; public :new; end
end

describe 'Panner' do
  shared_examples_for 'Panner' do
    before do
      @pan      = @class.send @method, *@params
      @inputs ||= @params
      @instance = @pan.first.source
    end
    
    it "should output a DelegatorArray" do
      @pan.should be_a(DelegatorArray)
    end
    
    it "should have correct rate" do
      @instance.rate.should == @rate
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

    it "should accept control rate inputs unless rate is audio"
  end
  
  shared_examples_for 'Panner with control rate' do
    before do
      @method = :kr
      @rate   = :control
    end
    it_should_behave_like 'Panner'
  end
  
  shared_examples_for 'Panner with audio rate' do
    before do
      @method = :ar
      @rate   = :audio
    end
    it_should_behave_like 'Panner'
    
    it "should just accept audio inputs if rate is audio" # do
     #      lambda { @class.new( :audio, MockUgen.new(:control) ) }.should raise_error(ArgumentError)
     #    end
  end
  
  shared_examples_for 'Panner with array as input' do
    it "should have n channels" do
      @arrayed.should have(@ugens.size).proxies
    end
    
    it "should have array as channel" do
      @arrayed.each { |a| a.should have(@channels).proxies }
    end
    
    it "should have the same source class" do
      @arrayed.flatten.source.uniq.should have(@ugens.size).elements
    end
  end
  
  shared_examples_for  'Multi input panner' do
    describe "two ugens as input" do
      before do
        @params[0] = @ugens = [@ugen] * 2
        @arrayed   = @class.ar *@params
      end
      it_should_behave_like 'Panner with array as input'
    end
    
    describe "four ugens as input" do
      before do
        @params[0] = @ugens = [@ugen] * 4
        @arrayed   = @class.ar *@params
        # p @arrayed.first.first.source.output_specs
      end
      it_should_behave_like 'Panner with array as input'
    end
  end
  
  describe Pan2 do
    before do
      @class    = Pan2
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 2
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'
    

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 2.0]
    end
  end

  describe LinPan2 do
    before do
      @class    = LinPan2
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 2
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 2.0]
    end
  end

  describe Pan4 do
    before do
      @class    = Pan4
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, 0.5, 0.5, 1.0
      @channels = 4
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'    

    it "should have keyword args" do
      @class.ar( @ugen, :level => 2.0 ).first.source.inputs.should == [@ugen, 0.0, 0.0, 2.0]
    end
  end

  describe Balance2 do
    before do
      @class    = Balance2
      @ugen     = MockUgen.new :audio, 1, 2
      @ugen2    = MockUgen.new :audio, 2, 4
      @params   = @ugen, @ugen2, 0.5, 1.0
      @channels = 2
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'

    it "should have keyword args" do
      @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    end
  end

  describe Rotate2 do
    before do
      @class    = Rotate2
      @ugen     = MockUgen.new :audio, 1, 2
      @ugen2    = MockUgen.new :audio, 2, 4
      @params   = @ugen, @ugen2, 0.5
      @channels = 2
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'
    
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe PanB do
    before do
      @class    = PanB
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, 0.5, 0.5, 1.0
      @channels = 4
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'
    
    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe PanB2 do
    before do
      @class    = PanB2
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, 0.5, 1.0
      @channels = 3
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'

    # it "should have keyword args" do
    #   @class.ar( @ugen, @ugen2 , :level => 2.0 ).first.source.inputs.should == [@ugen, @ugen2 , 0.0, 2.0]
    # end
  end

  describe BiPanB2 do
    before do
      @class    = BiPanB2
      @ugen2    = MockUgen.new(:audio, 2, 4)
      @ugen     = MockUgen.new :audio, 1, 2
      @params   = @ugen, @ugen2, 0.5, 0.5
      @channels = 3
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    it_should_behave_like 'Multi input panner'
    
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
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
    
  end
  
  describe DecodeB2, 'seven channels' do
    before do
      @class    = DecodeB2
      @params   = 7, 0.5, 0.5, 0.5, 0.5
      @inputs   = 0.5, 0.5, 0.5, 0.5
      @channels = 7
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
  end

  describe PanAz, 'five channels' do
    before do
      @class    = PanAz
      @ugen     = MockUgen.new(:audio, 1, 2)
      @params   = 5, @ugen, 0.5, 0.5, 0.5, 0.5
      @inputs   = @ugen, 0.5, 0.5, 0.5, 0.5
      @channels = 5
    end
    it_should_behave_like 'Panner with audio rate'
    it_should_behave_like 'Panner with control rate'
  end
end