require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require "named_arguments"


require "#{LIB_DIR}/audio/ugens/ugen_operations"
require "#{LIB_DIR}/audio/ugens/ugen"

require "#{LIB_DIR}/audio/ugens/operation_ugens"
require "#{LIB_DIR}/audio/ugens/ugens"
require "#{LIB_DIR}/audio/control_name"
require "#{LIB_DIR}/audio/synthdef"
require "#{LIB_DIR}/extensions"



include Scruby
include Audio
include Ugens


describe "building ugen graph" do
  before do
    @sdef  = SynthDef.new( :name ) do end
    @ugen  = Ugen.new( :audio, 100, 200 )
  end

  it "should return nil #sytnth_def" do
    @ugen.send( :synthdef ).should eql(nil)
  end
  
  it "should set synthdef to the synth def for ugens instantiated inside ugen graph" do
    function = lambda { Ugen.new( :audio, 100, 200 ).send( :synthdef ).should eql( @sdef ) }
    @sdef.send :build_ugen_graph, function, []
    Ugen.new( :audio, 100, 200 ).send( :synthdef ).should eql( nil )
  end

end

describe "encoding examples" do
  
  before :all do
    @sdef = 
    SynthDef.new(:cacahuate, :values => [1, 456, 0.34, 0.45]) do |gate, freq, ancho, amp|
      # sig = Pulse.ar( freq, ancho, amp, 0 )
      # env = EnvGen.kr( Env.asr(2, 1, 1), gate, :doneAction => 2 )
      # Out.ar( 0, sig*env )
    end
  end
  
  it do
  end
  
  
end
