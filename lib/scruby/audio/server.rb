require 'singleton'

module Scruby 
  module Audio
    include OSC
    
    class Message < OSC::Message
      def initialize command, *args
        args.peel!
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
      attr_reader :host, :port, :path, :buffers

      # Initializes and registers a new Server instance and sets the host and port for it.
      # The server is a Ruby representation of scsynth which can be a local binary or a remote    
      # server already running.
      # Server class keeps an array with all the instantiated servers
      def initialize host = 'localhost', port = 57111, path = '/Applications/SuperCollider/scsynth'
        @host    = host
        @port    = port
        @path    = path
        @buffers = []
        self.class.all << self
      end
      
      named_arguments_for :initialize
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
        sleep 0.1 until ready or !@thread.alive?
        sleep 0.5 # just to be shure
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
        send '/quit'
      end
      
      # Sends an OSC command to the scsyth server.
      # E.g. <tt>server.send('/dumpOSC', 1)</tt>
      def send command, *args
        $UDP_Sender.send command, @host, @port, *args
        self
      end
      
      # Encodes and sends a SynthDef to the scsynth server
      def send_synth_def synth_def
        send_message Bundle.new nil, Message.new( '/d_recv', Blob.new(synth_def.encode), 0 )
      end
      
      def send_message message #:nodoc:
        $UDP_Sender.send_message message, @host, @port
      end

      def allocate_buffers *buffers
        buffers.peel!
        if @buffers.compact.size + buffers.size > 1024 
          raise SCError, 'No more buffer numbers -- free some buffers before allocating more.'
        end
        @buffers += buffers
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