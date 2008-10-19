require File.join(File.expand_path(File.dirname(__FILE__)),"helper")

require "#{LIB_DIR}/../scruby"


describe "scruby" do
  it "should have UgenOperations::UNARY " do
    Scruby::UgenOperations::UNARY.should_not be_nil
  end
end