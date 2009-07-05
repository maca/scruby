require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")

require "#{SCRUBY_DIR}/audio/ugens/ugen_operations" 
require "#{SCRUBY_DIR}/audio/ugens/ugen"
require "#{SCRUBY_DIR}/audio/ugens/ugens"
require "#{SCRUBY_DIR}/extensions"


module UgenTest
end

class Klass
end

include Scruby
include Audio
include Ugens


describe Ugens do
  
  before do
    @udefs = YAML::load( File.open( "#{SCRUBY_DIR}/audio/ugens/ugen_defs.yaml" ) )
  end

  it 'should define Ugen classes' do
    @udefs.each_pair { |key, val| eval(key).should_not be_nil  }
  end

  it 'each ugen should be Ugen subclass' do
    @udefs.each_pair { |key, val| eval(key).superclass.should eql( Scruby::Audio::Ugens::Ugen )  }
  end

  it 'should resond to :ar and :kr' do
    Vibrato.should respond_to(:ar)
    Vibrato.should respond_to(:kr)
  end

  it "should use default values and passed values" do
    Gendy1.should_receive(:new).with( :audio, 10, 20, 1, 1, 550, 660, 0.5, 0.5, 12, 1 ).and_return( mock('ugen', :muladd => nil) )
    Gendy1.ar 10, 20, :knum => 1, :minfreq => 550
  end
  
  it "should raise argumen error if not passed required" do
    Gendy1.stub!(:new)
    lambda { Gendy1.ar }.should raise_error(ArgumentError)
  end

  #  it "should work with arrays"
end


