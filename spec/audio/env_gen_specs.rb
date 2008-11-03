require File.join( File.expand_path(File.dirname(__FILE__)), '..', "helper")

require 'named_arguments'
require "#{LIB_DIR}/audio/ugens/ugen_operations"
require "#{LIB_DIR}/audio/ugens/ugen"
require "#{LIB_DIR}/extensions"
require "#{LIB_DIR}/audio/env"
require "#{LIB_DIR}/audio/ugens/env_gen"

include Scruby
include Audio
include Ugens 


describe EnvGen do
  
  it "should have correct inputs" do
    envgen = EnvGen.kr( Env.adsr )
    envgen.rate.should == :control
    envgen.inputs.should == [ 1, 1, 0, 1, 0, 0, 3, 2, -99, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].collect{ |i| i.to_f  }
  end
  
end