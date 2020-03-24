module Scruby
  class SynthDef
    extend Forwardable

    attr_reader :graph
    def_delegators :graph, :encode, :send_to, :visualize


    def initialize(name = nil, &block)
      controls = catch(:args) { param_defaults(&block) }
      root_ugen = yield(*controls.keys)

      unless root_ugen.is_a? Ugen::Base
        raise TypeError, %W[
          expected return of block to be a Ugen::Base
          but it is `#{root_ugen.inspect}`
        ].join(" ")
      end

      @graph = Graph.new(root_ugen, name, **controls)
    end

    private

    def param_defaults(&block)
      found = false

      TracePoint.new(:b_call) { |t|
        next found = t.method_id == __method__ unless found

        throw :args,
          t.parameters.map { |_, n| [ n, t.binding.eval(n.to_s) ] }.to_h
      }.enable { yield }
    end
  end
end
