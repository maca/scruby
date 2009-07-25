require 'singleton'

module Scruby 
  module Audio
    include OSC
    
    class Message < OSC::Message
      def initialize command, *args
        args.peel!
        args.collect! do |arg|
          case arg
          when Array
            Blob.new self.class.new(*arg).encode
          when true
            1
          when false
            0
          when Symbol
            arg.to_s
          else
            arg
          end
        end
        super command, type_tags(args), *args
      end
      
      def type_tags *args
        args.peel!
        args.collect{ |arg| OSC::Packet.tag arg }.join
      end
    end
    
    class UDPSender < OSC::UDPServer #:nodoc:
      include Singleton

      alias :udp_send :send 
      def send command, host, port, *args
        args = args.collect{ |arg| arg.kind_of?( Symbol ) ? arg.to_s : arg }
        udp_send Message.new( command, *args ), 0, host, port
      end

      def send_message message, host, port
        udp_send message, 0, host, port
      end
    end
    $UDP_Sender = UDPSender.instance
    
    class Server
      attr_reader :host, :port, :path, :buffers, :control_buses, :audio_buses
      DEFAULTS = { :buffers => 1024, :control_buses => 4096, :audio_buses => 128, :audio_outputs => 8, :audio_inputs => 8 }.freeze
      
      # Initializes and registers a new Server instance and sets the host and port for it.
      # The server is a Ruby representation of scsynth which can be a local binary or a remote    
      # server already running.
      # Server class keeps an array with all the instantiated servers
      #   Options:
      #     +host+: 
      #       defaults to 'localhost'
      #     +port+:
      #       TCP port defaults to 57111
      #     +control_buses+
      #       Number of buses for routing control data defaults to 4096, indices start at 0.
      #     +audio_buses+
      #       Number of audio Bus channels for hardware output and input and internal routing, defaults to 128
      #     +audio_outputs+
      #       Reserved +buses+ for hardware output, indices available are 0 to +audio_outputs+ - 1 defaults to 8.
      #     +audio_inputs+
      #       Reserved +buses+ for hardware input, +audio_outputs+ to (+audio_outputs+ + +audio_inputs+ - 1), defaults to 8.
      #     +buffers+
      #       Number of available sample buffers defaults to 1024
      def initialize opts = {}
        @host          = opts.delete(:host) || 'localhost'
        @port          = opts.delete(:port) || 57111
        @path          = opts.delete(:path) || '/Applications/SuperCollider/scsynth'
        @opts          = DEFAULTS.dup.merge opts
        @buffers       = []
        @control_buses = []
        @audio_buses   = []
        Bus.audio self, @opts[:audio_outputs] # register hardware buses
        Bus.audio self, @opts[:audio_inputs]
        self.class.all << self
      end
      
      # Boots the local binary of the scsynth forking a process, it will rise a SCError if the scsynth 
      # binary is not found in /Applications/SuperCollider/scsynth (default Mac OS path) or given path. 
      # The default path can be overriden using Server.scsynt_path=('path')
      def boot
        raise SCError.new('Scsynth not found in the given path') unless File.exists? @path
        if running?
          warn "Server on port #{ @port } allready running"
          return self 
        end
        
        ready   = false
        @thread = Thread.new do
          IO.popen "cd #{ File.dirname @path }; ./#{ File.basename @path } -u #{ @port }" do |pipe|
            loop do 
              if response = pipe.gets
                puts response
                ready = true if response.match /ready/
              end
            end
          end
        end
        sleep 0.01 until ready or !@thread.alive?
        sleep 0.01 # just to be shure
        send "/g_new", 1  
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
      
      # Sends the /quit OSC signal to the scsynth
      def quit
        Server.all.delete self
        send '/quit'
      end
      
      # Sends an OSC command or +Message+ to the scsyth server.
      # E.g. +server.send('/dumpOSC', 1)+
      def send message, *args
        case message
        when Bundle, Message
          $UDP_Sender.send_message message, @host, @port
        else
          $UDP_Sender.send message, @host, @port, *args
        end
        self
      end
      
      def send_bundle timestamp = nil, *messages
        send Bundle.new( timestamp, *messages.map{ |message| Message.new *message  } )
      end
      
      # Encodes and sends a SynthDef to the scsynth server
      def send_synth_def synth_def
        send Bundle.new( nil, Message.new( '/d_recv', Blob.new(synth_def.encode), 0 ) )
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
end