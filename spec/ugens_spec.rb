require File.expand_path(File.dirname(__FILE__)) + "/helper"

require "scruby/control_name"
require "scruby/env"
require "scruby/ugens/ugen"
require "scruby/ugens/ugen_operations" 
require "scruby/ugens/ugens"


module UgenTest
end

class Klass
end

include Scruby
include Ugens


describe Ugens do
  
  before do
    @udefs = YAML::load( File.open( "#{ File.dirname __FILE__ }/../lib/scruby/ugens/ugen_defs.yaml" ) )
  end

  it 'should define Ugen classes' do
    @udefs.each_pair { |key, val| eval(key).should_not be_nil  }
  end

  it 'each ugen should be Ugen subclass' do
    @udefs.each_pair { |key, val| eval(key).superclass.should eql( Scruby::Ugens::Ugen )  }
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
  
  it "should print description" do
    PanAz.params.should == {
      :audio => [
        [:input, nil], 
        [:pos, 0], 
        [:level, 1], 
        [:width, 2], 
        [:orientation, 0.5], 
        [:mul, 1], 
        [:add, 0] ], 
      :control => [
        [:input, nil], 
        [:pos, 0], 
        [:level, 1], 
        [:width, 2], 
        [:orientation, 0.5], 
        [:mul, 1], 
        [:add, 0] ]}
  end

  #  it "should work with arrays"
end


