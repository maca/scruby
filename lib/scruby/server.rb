require 'singleton'

module Scruby 
  include OSC
  
  TrueClass.send :include, OSC::OSCArgument
  TrueClass.send(:define_method, :to_osc_type){ 1 }
  
  FalseClass.send :include, OSC::OSCArgument
  FalseClass.send(:define_method, :to_osc_type){ 0 }
  
  Hash.send :include, OSC::OSCArgument
  Hash.send :define_method, :to_osc_type do 
    self.to_a.collect{ |pair| pair.collect{ |a| OSC.coerce_argument a } }
  end

  Array.send(:include, OSC::OSCArgument)
  Array.send( :define_method, :to_osc_type) do
    Blob.new Message.new(*self).encode
  end

  class Server
    attr_reader :host, :port, :path, :buffers, :control_buses, :audio_buses
    DEFAULTS = { :buffers => 1024, :control_buses => 4096, :audio_buses => 128, :audio_outputs => 8, :audio_inputs => 8, 
      :host => 'localhost', :port => 57111, :path => '/Applications/SuperCollider/scsynth'
      }

    # Initializes and registers a new Server instance and sets the host and port for it.
    # The server is a Ruby representation of scsynth which can be a local binary or a remote    
    # server already running.
    # Server class keeps an array with all the instantiated servers
    # 
    # For more info 
    #   $ man scsynth
    # 
    # @param [Hash] opts the options to create a message with.
    # @option opts [String] :path ('scsynt' on Linux, '/Applications/SuperCollider/scsynth' on Mac) scsynth binary path
    # @option opts [String] :host ('localhost') SuperCollider Server address
    # @option opts [Fixnum] :port (57111) TCP port
    # @option opts [Fixnum] :control_buses (4096) Number of buses for routing control data, indices start at 0
    # @option opts [Fixnum] :audio_buses (8) Number of audio Bus channels for hardware output and input and internal routing
    # @option opts [Fixnum] :audio_outputs (8) Reserved buses for hardware output, indices start at 0
    # @option opts [Fixnum] :audio_inputs (8) Reserved buses for hardware input, indices starting from the number of audio outputs
    # @option opts [Fixnum] :buffers (1024) Number of available sample buffers
    # 
    def initialize opts = {}
      @opts          = DEFAULTS.dup.merge opts
      @buffers       = []
      @control_buses = []
      @audio_buses   = []
      @client        = Client.new port, host
      Bus.audio self, @opts[:audio_outputs] # register hardware buses
      Bus.audio self, @opts[:audio_inputs]
      self.class.all << self
    end
    
    def host; @opts[:host]; end
    def port; @opts[:port]; end
    def path; @opts[:path]; end

    # Boots the local binary of the scsynth forking a process, it will rise a SCError if the scsynth 
    # binary is not found in path. 
    # The default path can be overriden using Server.scsynt_path=('path')
    def boot
      raise SCError.new('Scsynth not found in the given path') unless File.exists? path
      if running?
        warn "Server on port #{ port } allready running"
        return self 
      end

      ready   = false
      timeout = Time.now + 2
      @thread = Thread.new do
        IO.popen "cd #{ File.dirname path }; ./#{ File.basename path } -u #{ port }" do |pipe|
          loop do 
            if response = pipe.gets
              puts response
              ready = true if response.match /ready/
            end
          end
        end
      end
      sleep 0.01 until ready or !@thread.alive? or Time.now > timeout
      sleep 0.01        # just to be shure
      send "/g_new", 1  # default group
      self   
    end

    def running?
      @thread and @thread.alive? ? true : false
    end

    def stop
      send "/g_freeAll", 0
      send "/clearSched"
      send "/g_new", 1
    end
    alias :panic :stop

    # Sends the /quit OSC signal to the scsynth
    def quit
      Server.all.delete self
      send '/quit'
    end

    # Sends an OSC command or +Message+ to the scsyth server.
    # E.g. +server.send('/dumpOSC', 1)+
    def send message, *args
      message = Message.new message, *args unless Message === message or Bundle === message
      @client.send message
    end

    def send_bundle timestamp = nil, *messages
      send Bundle.new( timestamp, *messages.map{ |message| Message.new *message  } )
    end

    # Encodes and sends a SynthDef to the scsynth server
    def send_synth_def synth_def
      send Bundle.new( nil, Message.new('/d_recv', Blob.new(synth_def.encode), 0) )
    end

    # Allocates either buffer or bus indices, should be consecutive
    def allocate kind, *elements
      collection = instance_variable_get "@#{kind}"
      elements.flatten!

      max_size = @opts[kind]
      if collection.compact.size + elements.size > max_size
        raise SCError, "No more indices available -- free some #{ kind } before allocating more."
      end

      return collection.concat(elements) unless collection.index nil # just concat arrays if no nil item

      indices = []
      collection.each_with_index do |item, index| # find n number of consecutive nil indices
        break if indices.size >= elements.size
        if item.nil?
          indices << index
        else
          indices.clear
        end
      end

      case 
      when indices.size >= elements.size
        collection[indices.first, elements.size] = elements
      when collection.size + elements.size <= max_size
        collection.concat elements
      else
        raise SCError, "No block of #{ elements.size } consecutive #{ kind } indices is available."
      end
    end

    @@servers = []
    class << self
      # Returns an array with all the registered servers
      def all
        @@servers
      end

      # Clear the servers array
      def clear
        @@servers.clear
      end

      # Return a server corresponding to the specified index of the registered servers array
      def [] index
        @@servers[index]
      end

      # Set a server to the specified index of the registered servers array
      def []= index
        @@servers[index]
        @@servers.uniq!
      end
    end
  end

  class SCError < StandardError
  end
end
