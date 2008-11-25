require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require "named_arguments"
require 'osc'

require "#{SCRUBY_DIR}/audio/ugens/ugen_operations"
require "#{SCRUBY_DIR}/audio/ugens/ugen"
require "#{SCRUBY_DIR}/audio/ugens/multi_out_ugens"
require "#{SCRUBY_DIR}/audio/ugens/in_out"

require "#{SCRUBY_DIR}/audio/ugens/operation_ugens"
require "#{SCRUBY_DIR}/audio/ugens/ugen"

require "#{SCRUBY_DIR}/audio/ugens/ugens"
require "#{SCRUBY_DIR}/audio/control_name"
require "#{SCRUBY_DIR}/audio/synthdef"
require "#{SCRUBY_DIR}/extensions"

require "#{SCRUBY_DIR}/audio/server"

require "#{SCRUBY_DIR}/audio/env"
require "#{SCRUBY_DIR}/audio/ugens/env_gen"

include Scruby
include Audio
include Ugens
include OperationUgens

describe "synthdef examples" do

  before :all do
    @sdef = SynthDef.new(:hola){ |a, b| SinOsc.kr( a ) + SinOsc.kr( b ) } 
    @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 97, 0, 0, 1, 98, 0, 1, 0, 4, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 2, 0, 0, 1, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, 0, 0, 1, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 1, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 1, 0, 0 ].pack('C*')
  end

  it "should have correct children" do
    @sdef.children[0].should be_instance_of( Control )
    @sdef.children[1].should be_instance_of( SinOsc )
    @sdef.children[2].should be_instance_of( SinOsc )
    @sdef.children[3].should be_instance_of( BinaryOpUGen )
  end

  it "should encode with control" do
    @sdef.encode.should == @expected
  end

  it "should encode with ops" do
    expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 101, 108, 112, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0, 2, 0, 0 ].pack('C*')
    SynthDef.new(:help){ (SinOsc.ar() + SinOsc.ar()) * SinOsc.ar() }.encode.should == expected
  end

  it "should encode with out" do
    sdef = SynthDef.new(:out){ Out.ar(0, SinOsc.ar) }
    sdef.children.should have(2).children
    
    sdef.children[0].should be_instance_of( SinOsc )
    sdef.children[1].should be_instance_of( Out ) 
    
    sdef.constants.should == [ 440, 0 ]
    sdef.children[1].channels.should == []
    
    expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 1, 0, 0, 0, 0, 0, 0 ].pack('C*')
    sdef.encode.should == expected
  end

  it "should encode another with out" do
    sdef = SynthDef.new(:out){ sig = SinOsc.ar(100, 200) * SinOsc.ar(200); Out.ar(0, sig) }
    
    sdef.should have(4).children
    sdef.children[0].should be_instance_of( SinOsc )
    sdef.children[1].should be_instance_of( SinOsc )
    sdef.children[2].should be_instance_of( BinaryOpUGen )
    sdef.children[3].should be_instance_of( Out )
    
    sdef.encode.should == [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 3, 66, -56, 0, 0, 67, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 2, 0, 2, 0, 0, 0, 0 ].pack('C*')
  end
  
  it "should encode out with two channels" do
    sdef = SynthDef.new( :out ){ sig = SinOsc.ar(100, [200, 200]) * SinOsc.ar(200); Out.ar(0, sig) }
    sdef.should have(6).children
    sdef.children[0..2].map { |u| u.should be_instance_of( SinOsc ) }
    sdef.children[3..4].map { |u| u.should be_instance_of( BinaryOpUGen ) }
    sdef.children[5].should be_instance_of( Out )
    
    expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 3, 66, -56, 0, 0, 67, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 1, 0, 0, 0, 2, 0, 0, 2, 3, 79, 117, 116, 2, 0, 3, 0, 0, 0, 0, -1, -1, 0, 2, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0 ].pack('C*')
    sdef.encode.should == expected
  end
  
  it "should encode out with multidimensional array" do
    sdef = SynthDef.new( :out ){ sig = SinOsc.ar(100, [200,[100, 100]]) * SinOsc.ar(200); Out.ar(0, sig) }
    sdef.should have(9).children
    child = sdef.children
    child[0..3].map { |u| u.should be_instance_of(SinOsc) }
    child[4].should be_instance_of(BinaryOpUGen)
    child[5].should be_instance_of(BinaryOpUGen)
    child[6].should be_instance_of(BinaryOpUGen)
    child[7].should be_instance_of(Out)
    child[8].should be_instance_of(Out)

    #the order of the elements is different than in supercollider, but at least has the encoded string is the same size so i guess its fine
    sdef.encode.should have(261).chars
  end
  
  it "should encode 'complex' sdef" do
    sdef = SynthDef.new( :am ) do |gate, portadora, moduladora, amp|
      modulacion=SinOsc.kr(moduladora,0,0.5,0.5)
      sig=SinOsc.ar(portadora,0,modulacion)
      env=EnvGen.kr(Env.asr(2,1,2),gate, :doneAction => 2)
      Out.ar(0,sig*env);
    end
    sdef.children.should have(8).children
    sdef.constants.should == [0, 0.5, 1, 2, -99, 5, -4]
    
    expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 97, 109, 0, 7, 0, 0, 0, 0, 63, 0, 0, 0, 63, -128, 0, 0, 64, 0, 0, 0, -62, -58, 0, 0, 64, -96, 0, 0, -64, -128, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 103, 97, 116, 101, 0, 0, 9, 112, 111, 114, 116, 97, 100, 111, 114, 97, 0, 1, 10, 109, 111, 100, 117, 108, 97, 100, 111, 114, 97, 0, 2, 3, 97, 109, 112, 0, 3, 0, 8, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 4, 0, 0, 1, 1, 1, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 2, -1, -1, 0, 0, 1, 6, 77, 117, 108, 65, 100, 100, 1, 0, 3, 0, 1, 0, 0, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 1, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, 0, 0, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 3, 0, 0, 0, 2, 0, 0, 2, 6, 69, 110, 118, 71, 101, 110, 1, 0, 17, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 2, -1, -1, 0, 0, -1, -1, 0, 2, -1, -1, 0, 3, -1, -1, 0, 0, -1, -1, 0, 3, -1, -1, 0, 2, -1, -1, 0, 4, -1, -1, 0, 2, -1, -1, 0, 3, -1, -1, 0, 5, -1, -1, 0, 6, -1, -1, 0, 0, -1, -1, 0, 3, -1, -1, 0, 5, -1, -1, 0, 6, 1, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 4, 0, 0, 0, 5, 0, 0, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 0, 0, 6, 0, 0, 0, 0 ].pack('c*')
    sdef.encode.should == expected
  end


end

