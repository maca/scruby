# class ControlName; end

# include Scruby

# RSpec.describe Env do
#   it "Env.new [0,1,0], [0.5, 1]" do
#     env = Env.new [ 0, 1, 0 ], [ 0.5, 1 ]
#     expect(env.times).to         eq([ 0.5, 1 ])
#     expect(env.levels).to        eq([ 0, 1, 0 ])
#     expect(env.shape_numbers).to eq([ 1 ])
#     expect(env.curve_values).to  eq([ 0 ])
#   end

#   it do
#     env = Env.new [ 0, 1, 0 ], [ 0.5, 1 ]
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 2, -99, -99, 1, 0.5, 1, 0, 0, 1, 1, 0 ].map(&:to_f))
#   end

#   it do
#     expect(Env.perc).to be_instance_of(Env)
#   end

#   it "#perc" do
#     perc = Env.perc
#     expect(perc.to_array.map(&:to_f)).to eq([ 0, 2, -99, -99, 1, 0.01, 5, -4, 0, 1, 5, -4 ].map(&:to_f))
#   end

#   it "#sine" do
#     env = Env.sine
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 2, -99, -99, 1, 0.5, 3, 0, 0, 0.5, 3, 0 ].map(&:to_f))
#   end

#   it "#linen" do
#     env = Env.linen
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 3, -99, -99, 1, 0.01, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0 ].map(&:to_f))
#   end

#   it "#triangle" do
#     env = Env.triangle
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 2, -99, -99, 1, 0.5, 1, 0, 0, 0.5, 1, 0 ].map(&:to_f))
#   end

#   it "#cutoff" do
#     env = Env.cutoff
#     expect(env.to_array.map(&:to_f)).to eq([ 1, 1, 0, -99, 0, 0.1, 1, 0 ].map(&:to_f))
#   end

#   it "#dadsr" do
#     env = Env.dadsr
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 4, 3, -99, 0, 0.1, 5, -4, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].map(&:to_f))
#   end

#   it "#dadsr" do
#     env = Env.adsr
#     expect(env.to_array.map(&:to_f)).to eq([ 0, 3, 2, -99, 1, 0.01, 5, -4, 0.5, 0.3, 5, -4, 0, 1, 5, -4 ].map(&:to_f))
#   end

#   describe "Overriding defaults" do

#     it "#asr" do
#       expect(Env.asr(2, 1, 2).to_array).to eq([ 0, 2, 1, -99, 1, 2, 5, -4, 0, 2, 5, -4 ])
#     end

#   end

# end
