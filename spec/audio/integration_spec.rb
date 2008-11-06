require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require "named_arguments"


require "#{LIB_DIR}/audio/ugens/ugen_operations"
require "#{LIB_DIR}/audio/ugens/ugen"
require "#{LIB_DIR}/audio/ugens/multi_out_ugens"

require "#{LIB_DIR}/audio/ugens/operation_ugens"
require "#{LIB_DIR}/audio/ugens/ugen"

require "#{LIB_DIR}/audio/ugens/ugens"
require "#{LIB_DIR}/audio/control_name"
require "#{LIB_DIR}/audio/synthdef"
require "#{LIB_DIR}/extensions"

include Scruby
include Audio
include Ugens
include OperationUgens


describe "synthdef examples" do
  
  before do
    @sdef = SynthDef.new(:hola){ |a, b| SinOsc.kr( a ) + SinOsc.kr( b ) } 
    @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 97, 0, 0, 1, 98, 0, 1, 0, 4, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 2, 0, 0, 1, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, 0, 0, 1, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 1, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 1, 0, 0 ].pack('C*')
  end
  
  it "should have correct children" do
    @sdef.should have(4).children
    @sdef.children[0].should be_instance_of( Control )
    @sdef.children[1].should be_instance_of( SinOsc )
    @sdef.children[2].should be_instance_of( SinOsc )
    @sdef.children[3].should be_instance_of( BinaryOpUGen )
  end
  
  it "should encode" do
    @sdef.encode.should == @expected
  end
  
  it "should encode" do
    expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 101, 108, 112, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0, 2, 0, 0 ].pack('C*')
    SynthDef.new(:help){ (SinOsc.ar() + SinOsc.ar()) * SinOsc.ar() }.encode.should == expected
  end
  
  
  
end
