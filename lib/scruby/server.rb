require "ruby-osc"
require "concurrent-edge"


module Scruby
  class Server
    include OSC

    attr_reader :host, :port, :executable, :client, :message_queue

    def initialize(host: "127.0.0.1", port: 57_110)
      @host = host
      @port = port
      @message_queue = MessageQueue.new(self)
    end

    def boot(binary: "scsynth", **opts)
      @executable = Executable.spawn(binary, **opts, **{ port: port })

      message_queue.sync.then { continue_boot }
    end

    def client
      @client ||= OSC::Client.new(port, host)
    end


    def dump_osc(code)
      send "/dumpOSC", code
    end

    def continue_boot
      send "/g_new", 1
    end

    def stop
      send "/g_freeAll", 0
      send "/clearSched"
      send "/g_new", 1
    end
    alias panic stop

    def quit
      send "/quit"
    end

    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send(message, *args)
      unless OSC::Message === message or OSC::Bundle === message
        message = OSC::Message.new(message, *args)
      end

      client.send message
    end

    def send_bundle(timestamp = nil, *messages)
      bundle = messages.map{ |message| OSC::Message.new(*message) }
      send OSC::Bundle.new(timestamp, *bundle)
    end

    # Encodes and sends a SynthDef to the scsynth server
    def send_synth_def(synth_def)
      message =
        OSC::Message.new("/d_recv", OSC::Blob.new(synth_def.encode), 0)

      send OSC::Bundle.new(nil, message)
    end

    # def initialize(buffers: 1024,
    #                host: "localhost",
    #                port: 57_111,
    #                control_buses: 4096,
    #                audio_buses: 128,
    #                audio_outputs: 8,
    #                audio_inputs: 8)
    #   @buffers = buffers
    #   @host = host
    #   @port = port
    #   @control_buses = control_buses
    #   @audio_buses = audio_buses
    #   @audio_outputs = audio_outputs
    #   @audio_inputs = audio_inputs
    #   Bus.audio(self, audio_inputs)
    #   Bus.audio(self, audio_outputs)
    #   self.binary = binary
    #   self.class.all << self
    # end

    # Allocates either buffer or bus indices, should be consecutive
    def allocate(kind, *elements)
      # collection = instance_variable_get "@#{kind}"
      # elements.flatten!

      # max_size = 2000 #@opts[kind]

      # if collection.compact.size + elements.size > max_size
      #   raise SCError, "No more indices available -- free some #{kind} before allocating more."
      # end

      # unless collection.index nil # just concat arrays if no nil item
      #   return collection.concat(elements)
      # end

      # indices = []

      # # find n number of consecutive nil indices
      # collection.each_with_index do |item, index|
      #   break if indices.size >= elements.size

      #   if item.nil?
      #     indices << index
      #   else
      #     indices.clear
      #   end
      # end

      # if indices.size >= elements.size
      #   collection[indices.first, elements.size] = elements
      # elsif collection.size + elements.size <= max_size
      #   collection.concat elements
      # else
      #   msg =
      #     [ "No block of #{elements.size} consecutive",
      #       "#{kind} indices is available." ]
      #   raise SCError, msg.join(" ")
      # end
    end
  end
end
