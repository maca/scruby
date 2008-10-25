require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'

require "#{LIB_DIR}/audio/ugens/ugen_operations" 
require "#{LIB_DIR}/audio/ugens/ugen" 
require "#{LIB_DIR}/audio/ugens/ugens" 
require "#{LIB_DIR}/extensions"

module UgenTest
end

class Klass
end


include Scruby
include Audio
include Ugens


describe Ugens do
  
  before do
    @udefs = Ugens::UGEN_DEFS
  end
  
  it do
    Ugens::UGEN_DEFS.should be_instance_of(Hash)
  end
  
  it do
    @udefs.each_pair { |key, val| eval(key).should_not be_nil  }
  end
  
  it do
    @udefs.each_pair { |key, val| eval(key).superclass.should eql( Scruby::Audio::Ugens::Ugen )  }
  end
  
  it do
    Vibrato.should respond_to(:ar)
    Vibrato.should respond_to(:kr)
  end
  
end


