require File.join( File.expand_path(File.dirname(__FILE__)), '..', "helper")

require "scruby/audio/control_name"
require "scruby/audio/ugens/ugen"
require "scruby/audio/ugens/ugen_operations"
require "scruby/audio/env"
require "scruby/audio/ugens/env_gen"

include Scruby
include Audio
include Ugens 

describe EnvGen do
  
  it "should not instantiate with #new" do
    lambda { EnvGen.new :audio, 1, 2 }.should raise_error
  end
  
  it "should have correct inputs" do
    envgen = EnvGen.kr Env.adsr
    envgen.rate.should   == :control
    envgen.inputs.should == [ 1, 1, 0, 1, 0, 0, 3, 2, -99, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].collect{ |i| i.to_f  }
  end
end