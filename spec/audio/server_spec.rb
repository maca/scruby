require File.join( File.expand_path(File.dirname(__FILE__)), '..',"helper")
require 'yaml'
require 'tempfile'

require 'named_arguments'
require 'osc'
require "#{SCRUBY_DIR}/audio/server"

include Scruby
include Audio


describe Server do
  
  it "should not rise scynth not found error" do
    File.stub!( :exists ).and_return( true )
    lambda{ Server.new.boot }.should_not raise_error(Server::SCError)
  end
  
  it "should raise scsynth not found error" do
    Server.sc_path = '/Applications/SuperCollider/not_scsynth'
    lambda{ Server.new.boot }.should raise_error(Server::SCError)
  end
  
  

end 

