require File.join( File.expand_path(File.dirname(__FILE__)),"helper")


require "scruby/audio/ugens/ugen"
require "scruby/audio/ugens/ugen_operations"
require "scruby/audio/env"

class ControlName; end

include Scruby

describe Env do  
  it "Env.new [0,1,0], [0.5, 1]" do
    env = Env.new [0,1,0], [0.5, 1]
    env.times.should         == [0.5, 1]
    env.levels.should        == [ 0, 1, 0 ]
    env.shape_numbers.should == [1]
    env.curve_values.should  == [0]
  end
  
  it do
    env = Env.new [0,1,0], [0.5, 1]
    env.to_array.collect{ |i| i.to_f }.should == [ 0, 2, -99, -99, 1, 0.5, 1, 0, 0, 1, 1, 0 ].collect{ |i| i.to_f }
  end

  it do
    Env.perc.should be_instance_of( Env )
  end

  it "#perc" do
    perc = Env.perc
    perc.to_array.collect{ |i| i.to_f }.should == [ 0, 2, -99, -99, 1, 0.01, 5, -4, 0, 1, 5, -4 ].collect{ |i| i.to_f }
  end

  it '#sine' do
    env = Env.sine
    env.to_array.collect{ |i| i.to_f }.should == [ 0, 2, -99, -99, 1, 0.5, 3, 0, 0, 0.5, 3, 0 ].collect{ |i| i.to_f }
  end

  it "#linen" do
    env = Env.linen
    env.to_array.collect{ |i| i.to_f }.should == [ 0, 3, -99, -99, 1, 0.01, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0 ].collect{ |i| i.to_f }
  end

  it "#triangle" do
    env = Env.triangle
    env.to_array.collect{ |i| i.to_f }.should ==  [ 0, 2, -99, -99, 1, 0.5, 1, 0, 0, 0.5, 1, 0 ].collect{ |i| i.to_f }
  end

  it "#cutoff" do
    env = Env.cutoff
    env.to_array.collect{ |i| i.to_f }.should ==  [ 1, 1, 0, -99, 0, 0.1, 1, 0 ].collect{ |i| i.to_f }
  end

  it "#dadsr" do
    env = Env.dadsr
    env.to_array.collect{ |i| i.to_f }.should == [ 0, 4, 3, -99, 0, 0.1, 5, -4, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].collect{ |i| i.to_f }
  end
  
  it "#dadsr" do
    env = Env.adsr
    env.to_array.collect{ |i| i.to_f }.should == [ 0, 3, 2, -99, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].collect{ |i| i.to_f }
  end
  
  describe 'Overriding defaults' do
    
    it "#asr" do
      Env.asr(2, 1, 2).to_array.should == [ 0, 2, 1, -99, 1, 2, 5, -4, 0, 2, 5, -4 ]
    end
    
  end
  
end