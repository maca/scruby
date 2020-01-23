# include Scruby
# include Ugens

# RSpec.describe "synthdef examples" do

#   before :all do
#     @sdef = SynthDef.new :hola do |a, b| SinOsc.kr(a) + SinOsc.kr(b) end
#     @expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 97, 0, 0, 1, 98, 0, 1, 0, 4, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 2, 0, 0, 1, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, 0, 0, 1, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 1, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 1, 0, 0 ].pack("C*")
#   end

#   it "should have correct children" do
#     expect(@sdef.children[0]).to be_instance_of(Control)
#     expect(@sdef.children[1]).to be_instance_of(SinOsc)
#     expect(@sdef.children[2]).to be_instance_of(SinOsc)
#     expect(@sdef.children[3]).to be_instance_of(BinaryOpUGen)
#   end

#   it "should encode with control" do
#     expect(@sdef.encode).to eq(@expected)
#   end

#   it "should encode with ops" do
#     expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 101, 108, 112, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0, 2, 0, 0 ].pack("C*")
#     expect(SynthDef.new(:help){ (SinOsc.ar + SinOsc.ar) * SinOsc.ar }.encode).to eq(expected)
#   end

#   it "should encode with out" do
#     sdef = SynthDef.new(:out){ Out.ar(0, SinOsc.ar) }
#     expect(sdef.children.size).to eq(2)

#     expect(sdef.children[0]).to be_instance_of(SinOsc)
#     expect(sdef.children[1]).to be_instance_of(Out)

#     expect(sdef.constants).to eq([ 440, 0 ])
#     expect(sdef.children[1].channels).to eq([])

#     expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 1, 0, 0, 0, 0, 0, 0 ].pack("C*")
#     expect(sdef.encode).to eq(expected)
#   end

#   it "should encode another with out" do
#     sdef = SynthDef.new(:out){ sig = SinOsc.ar(100, 200) * SinOsc.ar(200); Out.ar(0, sig) }
#     expect(sdef.encode).to eq([ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 3, 66, -56, 0, 0, 67, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 2, 0, 2, 0, 0, 0, 0 ].pack("C*"))
#   end

#   it "should encode out with two channels" do
#     sdef = SynthDef.new(:out){ sig = SinOsc.ar(100, [ 200, 200 ]) * SinOsc.ar(200); Out.ar(0, sig) }
#     expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 3, 111, 117, 116, 0, 3, 66, -56, 0, 0, 67, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 2, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 1, 0, 0, 0, 2, 0, 0, 2, 3, 79, 117, 116, 2, 0, 3, 0, 0, 0, 0, -1, -1, 0, 2, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0 ].pack("C*")
#     expect(sdef.encode).to eq(expected)
#   end

#   it "should instantiate and encode" do
#     expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 101, 108, 112, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0, 2, 0, 0 ].pack("C*")
#     expect(SynthDef.new(:help){ (SinOsc.ar + SinOsc.ar) * SinOsc.ar }.encode).to eq(expected)
#   end

#   it "should encode out with multidimensional array" do
#     sdef = SynthDef.new(:out){ sig = SinOsc.ar(100, [ 200, [ 100, 100 ]]) * SinOsc.ar(200); Out.ar(0, sig) }
#     children = sdef.children
#     children[0..3].map { |u| expect(u).to be_instance_of(SinOsc) }
#     expect(children[4]).to be_instance_of(BinaryOpUGen)
#     expect(children[5]).to be_instance_of(BinaryOpUGen)
#     expect(children[6]).to be_instance_of(BinaryOpUGen)
#     expect(children[7]).to be_instance_of(Out)
#     expect(children[8]).to be_instance_of(Out)
#     # the order of the elements is different than in supercollider, but at least has the encoded string is the same size so i guess its fine
#     expect(sdef.encode.size).to eq(261)
#   end

#   it "should encode 'complex' sdef" do
#     sdef = SynthDef.new :am do |gate, portadora, moduladora, _amp|
#       mod = SinOsc.kr moduladora, 0, 0.5, 0.5
#       sig = SinOsc.ar portadora, 0, mod
#       env = EnvGen.kr Env.asr(2, 1, 2), gate, doneAction: 2
#       Out.ar 0, sig * env
#     end

#     expect(sdef.children.size).to eq(8)
#     expect(sdef.constants).to eq([ 0, 0.5, 1, 2, -99, 5, -4 ])
#     expected = [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 2, 97, 109, 0, 7, 0, 0, 0, 0, 63, 0, 0, 0, 63, -128, 0, 0, 64, 0, 0, 0, -62, -58, 0, 0, 64, -96, 0, 0, -64, -128, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 103, 97, 116, 101, 0, 0, 9, 112, 111, 114, 116, 97, 100, 111, 114, 97, 0, 1, 10, 109, 111, 100, 117, 108, 97, 100, 111, 114, 97, 0, 2, 3, 97, 109, 112, 0, 3, 0, 8, 7, 67, 111, 110, 116, 114, 111, 108, 1, 0, 0, 0, 4, 0, 0, 1, 1, 1, 1, 6, 83, 105, 110, 79, 115, 99, 1, 0, 2, 0, 1, 0, 0, 0, 0, 0, 2, -1, -1, 0, 0, 1, 6, 77, 117, 108, 65, 100, 100, 1, 0, 3, 0, 1, 0, 0, 0, 1, 0, 0, -1, -1, 0, 1, -1, -1, 0, 1, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, 0, 0, 0, 1, -1, -1, 0, 0, 2, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 3, 0, 0, 0, 2, 0, 0, 2, 6, 69, 110, 118, 71, 101, 110, 1, 0, 17, 0, 1, 0, 0, 0, 0, 0, 0, -1, -1, 0, 2, -1, -1, 0, 0, -1, -1, 0, 2, -1, -1, 0, 3, -1, -1, 0, 0, -1, -1, 0, 3, -1, -1, 0, 2, -1, -1, 0, 4, -1, -1, 0, 2, -1, -1, 0, 3, -1, -1, 0, 5, -1, -1, 0, 6, -1, -1, 0, 0, -1, -1, 0, 3, -1, -1, 0, 5, -1, -1, 0, 6, 1, 12, 66, 105, 110, 97, 114, 121, 79, 112, 85, 71, 101, 110, 2, 0, 2, 0, 1, 0, 2, 0, 4, 0, 0, 0, 5, 0, 0, 2, 3, 79, 117, 116, 2, 0, 2, 0, 0, 0, 0, -1, -1, 0, 0, 0, 6, 0, 0, 0, 0 ].pack("c*")
#     expect(sdef.encode).to eq(expected)
#   end
# end
