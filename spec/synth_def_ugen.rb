require File.join( File.expand_path(File.dirname(__FILE__)),"helper")


require "#{LIB_DIR}/audio/ugen_operations" 
require "#{LIB_DIR}/audio/ugen" 
require "#{LIB_DIR}/extensions"
require "#{LIB_DIR}/synthdef" 
# require "#{LIB_DIR}/control_name" 
require "#{LIB_DIR}/audio/ugen"

Dir.glob( File.join(LIB_DIR, "*.rb") ).each{ |f| require f  } #require all files in lib/audio

include Scruby
include Audio


describe "building ugen graph" do
  before do
    @sdef  = SynthDef.new( :name ) do end
    @ugen  = Ugen.new( :audio, 100, 200 )
  end
  
  it do
    @sdef.should respond_to(:build_ugen_graph)
  end
  
  it "should return nil #sytnth_def" do
    @ugen.synthdef.should eql(nil)
  end
  
  it "should set @sdef #synthdef=" do
    function = lambda{}
    Ugen.should_receive( :synthdef= ).with( @sdef )
    Ugen.should_receive( :synthdef= ).with( nil )      
    @sdef.build_ugen_graph( function )
  end
  
  it "should set synthdef to the synth def for ugens instantiated inside ugen graph" do
    function = lambda { Ugen.new( :audio, 100, 200 ).synthdef.should eql( @sdef ) }
    @sdef.build_ugen_graph function
    Ugen.new( :audio, 100, 200 ).synthdef.should eql( nil )
  end
  


end