require File.join( File.expand_path(File.dirname(__FILE__)),"../helper")

require "#{LIB_DIR}/audio/ugens/ugen_operations"
require "#{LIB_DIR}/extensions"
require "#{LIB_DIR}/audio/ugens/ugen"
require "#{LIB_DIR}/audio/ugens/multi_out_ugens"
require "#{LIB_DIR}/audio/ugens/in_out"


require 'named_arguments'

include Scruby
include Audio
include Ugens


describe In do
  
  it "respond to #kr and #ar "do
    In.should respond_to(:kr)
    In.should respond_to(:ar)
  end
  
  it "should instatiate with #ar" do
    ar = In.ar(0, 2)
    ar.should be_instance_of( In )
    ar.rate.should == :audio
    ar.inputs.should == [2,0]
  end
  
  it "should instatiate with #kr" do
    kr = In.kr(0, 2)
    kr.should be_instance_of( In )
    kr.rate.should == :control
    kr.inputs.should == [2,0]
  end
  

  
end

describe AbstractOut do
  
end

describe Out do
end
