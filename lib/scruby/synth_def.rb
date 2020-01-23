module Scruby
  class SynthDef
    attr_reader :name, :children, :constants, :variants, :control_names


    def initialize(name, rates: [], &block)
      @name = name.to_s
      @children = []

      unless block_given?
        raise ArgumentError, "An UGen graph (block) must be passed"
      end

      @control_names = collect_control_names block, values, rates
      build_ugen_graph block, @control_names
      @constants = collect_constants @children

      @variants = [] # stub!!!
    end


    def encode
      controls = control_names.reject(&:non_control?)
      encoded_controls =
        [ controls.size ].pack("n") +
        controls.map{ |c| c.name.encode + [ c.index ].pack("n") }.join

      init_stream +
        name.encode +
        constants.encode_floats +
        values.flatten.encode_floats +
        encoded_controls +
        [ children.size ].pack("n") + children.map(&:encode).join +
        [ variants.size ].pack("n") # stub!!!
    end

    def init_stream(file_version = 1, number_of_synths = 1) #:nodoc:
      "SCgf" + [ file_version ].pack("N") + [ number_of_synths ].pack("n")
    end

    def values #:nodoc:
      @control_names.map(&:value)
    end

    alias send_msg send
    # Sends itself to the given servers. One or more servers or an
    # array of servers can be passed.  If no arguments are given the
    # synthdef gets sent to all instantiated servers
    #
    # E.g.
    #   s = Server.new('localhost', 5114)
    #   s.boot
    #   r = Server.new('127.1.1.2', 5114)
    #
    #   SynthDef.new('sdef'){ Out.ar(0, SinOsc.ar(220)) }.send(s)
    #   # this synthdef is only sent to s
    #
    #   SynthDef.new('sdef2'){ Out.ar(1, SinOsc.ar(222)) }.send
    #   # this synthdef is sent to both s and r
    #
    def send(*servers)
      servers.peel!

      (servers.empty? ? Server.all : servers)
        .each{ |s| s.send_synth_def(self) }
      self
    end

    private

    def collect_control_names(function, values, rates)
      names = function.arguments

      names.zip(values, rates).each_with_index.map do |array, index|
        ControlName.new(*(array << index))
      end
    end

    def build_controls(control_names)
      # control_names.select{ |c| c.rate == :noncontrol }
      # .sort_by{ |c| c.control_name.index } +

      %i(scalar trigger control).map do |rate|
        same_rate_array =
          control_names.select{ |control| control.rate == rate }

        unless same_rate_array.empty?
          Control.and_proxies_from(same_rate_array)
        end
      end.flatten.compact.sort_by{ |proxy| proxy.control_name.index }
    end

    def build_ugen_graph(function, control_names)
      Thread.current[:synth_def] = self
      function.call *build_controls(control_names)

    ensure
      Thread.current[:synth_def] = nil
    end

    def collect_constants(children)
      children.send(:collect_constants).flatten.compact.uniq
    end
  end
end
