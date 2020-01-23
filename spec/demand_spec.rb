# include Scruby
# include Ugens

# class MockUgen < Ugen
#   class << self; public :new; end
# end

# RSpec.describe Demand do
#   shared_examples_for "Demand Ugen" do
#     before do
#       @prox     = @splatted ? Demand.send(@method, *@ugens) : Demand.send(@method, @ugens)
#       @instance = @splatted ? @prox.source : @prox.first.source
#     end

#     it "should output proxies or single proxie" do
#       @splatted ? @prox.each{ |prox| expect(prox).to be_a(OutputProxy) } : expect(@prox).to(be_a(OutputProxy))
#     end
#   end

#   shared_examples_for "Demand with ar" do
#     before do
#       @method = :ar
#     end
#     it_should_behave_like "Demand Ugen"
#   end

#   shared_examples_for "Demand with kr" do
#     before do
#       @method = :ar
#     end
#     it_should_behave_like "Demand Ugen"
#   end



#   describe "Single channel splatted input" do
#     before do
#       @channels = 1
#       @ugens    = [ MockUgen.new(:audio, 1, 2) ] * 4
#       @splatted = true
#     end

#   end

#   describe "Single channel array input" do
#     before do
#       @channels = 1
#       @ugens    = [ MockUgen.new(:audio, 1, 2) ] * 4
#       @splatted = false
#     end

#   end

#   # describe "Two channel splatted input" do
#   #   before do
#   #     @channels = 2
#   #     @splatted = false
#   #   end
#   #
#   # end
#   #
#   # describe "Two channel array input" do
#   #   before do
#   #     @channels = 2
#   #     @splatted = false
#   #   end
#   #
#   # end

# end
