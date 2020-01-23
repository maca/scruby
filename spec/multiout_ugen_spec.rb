# include Scruby
# include Ugens

# class Control
#   class << self
#     public :new
#   end
# end

# RSpec.describe Control do
#   before do
#     sdef = double("SynthDef", children: [])
#     allow(Ugen).to receive(:synthdef).and_return(sdef)

#     @proxy = double(OutputProxy, instance_of_proxy?: true)
#     allow(OutputProxy).to receive(:new).and_return(@proxy)

#     @names = Array.new(rand(3..9)) do |i|
#       ControlName.new "control_#{i}", 1, :control, i
#     end

#     @proxies = Control.new(:audio, *@names)
#     @control = sdef.children.first
#   end

#   it "should return an array of proxies" do
#     expect(@proxies).to be_a(DelegatorArray)
#     expect(@proxies.size).to eq(@names.size)
#   end

#   it "should set channels" do
#     expect(@control).to be_instance_of(Control)
#     expect(@control.channels).to eq(@names.map{ @proxy })
#   end

#   it "should be added to synthdef" do
#     expect(Ugen).to receive(:synthdef)
#     Control.new(:audio, [])
#   end

#   it "should instantiate with #and_proxies_from" do
#     expect(Control).to receive(:new).with(:control, *@names)
#     Control.and_proxies_from(@names)
#   end

#   it "should have index" do
#     expect(@control.index).to eq(0)
#   end

# end

# RSpec.describe OutputProxy do

#   before do
#     @sdef = double("sdef", children: [])
#     allow(Ugen).to receive(:synthdef).and_return(@sdef)
#     @name = ControlName.new("control", 1, :control, 0)
#     @names = [ @name ]
#     @output_index = 1
#   end

#   it "should receive index from control" do
#     expect(Control.and_proxies_from(@names).first.index).to eq(0)
#     expect(@sdef.children.first.index).to eq(0)
#   end

#   it "should have empty inputs" do
#     expect(OutputProxy.new(:audio, @name, @output_index, @name).inputs).to eq([])
#   end

#   it "should not be added to synthdef" do
#     expect(Ugen).not_to receive(:synthdef)
#     OutputProxy.new(:audio, @name, @output_index, @name)
#   end
# end
