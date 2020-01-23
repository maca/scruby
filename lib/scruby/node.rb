module Scruby
  class Node
    @@base_id = 999
    attr_reader :servers, :group, :id

    ACTIONS = %i(head tail before after replace).freeze

    def initialize(*args)
      args.flatten!
      args.compact!
      args.each{ |s| raise TypeError, "#{s} should be instance of Server" unless Server === s }
      @id      = args.pop if args.last.is_a? Integer
      @servers = args.empty? ? Server.all : args
      @id    ||= @@base_id += 1
    end

    def set(args = {})
      send "/n_set", id, *args.to_a.flatten
      self
    end

    def free
      send "/n_free", id
      @group, @playing, @running = nil, false, false
      self
    end

    def run(run = true)
      send "/n_run", id, run
      self
    end

    # Map controls in this Node to read from control or audio rate Buses. Controls are defined in a SynthDef as args or instances of
    # Control or its subclasses. They are specified here using symbols, strings, or indices, and are listed in pairs with Bus objects.
    # The number of sequential controls mapped corresponds to the Bus' number of channels. If this Node is a Group this will map all
    # Nodes within the Group. Note that with mapMsg if you mix audio and control rate busses you will get an Array of two messages
    # rather than a single message. Integer bus indices are assumed to refer to control buses. To map a control to an audio bus, you
    # must use a Bus object.
    def map(args)
      control, audio, content = [ "/n_mapn", id ], [ "/n_mapan", id ], []
      args = args.to_a.each do |param, bus|
        raise ArgumentError, "`#{ control }` is not a Bus" unless bus.is_a? Bus

        array = audio   if bus.rate == :audio
        array = control if bus.rate == :control
        array&.push param, bus.index, bus.channels
      end
      content << control unless control.empty?
      content << audio   unless audio.empty?
      send_bundle nil, *content
      self
    end

    # mapn
    def trace
      send "/n_trace", id
      self
    end

    def move_before(node)
      @group = node.group
      send "/n_before", id, node.id
      self
    end

    def move_after(node)
      @group = node.group
      send "/n_after", id, node.id
      self
    end

    # def move_to_head group
    #   @group = node.group
    #   @server.each{ |s| s.send '/n_after', self.id, node.id }
    # end
    #
    # def move_to_tail group
    #   @group = node.group
    #   @server.each{ |s| s.send '/n_after', self.id, node.id }
    # end

    def playing?; @playing || false; end
    alias running? playing?

    # Reset the node count
    def self.reset!
      @@base_id = 2000
    end

    # Sends a bundle to all registered +servers+ for this node
    def send_bundle(timestamp, *messages)
      bundle = Bundle.new(timestamp, *messages.map{ |message| Message.new *message })
      @servers.each{ |s| s.send bundle  }
    end

    # Sends a message to all registered +servers+ for this node
    def send(command, *args)
      message = Message.new command, *args
      @servers.each{ |s| s.send message }
      self
    end
  end
end
