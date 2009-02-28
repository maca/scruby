require 'singleton'

module Scruby 
  module Audio
    class UDPSender < OSC::UDPServer #:nodoc:
      include Singleton

      alias :udp_send :send 
      def send( command, host, port, *args )
        args = args.collect{ |arg| arg.kind_of?(Symbol) ? arg.to_s : arg }
        udp_send( OSC::Message.new( command, type_tag(args), *args ), 0, host, port )
      end

      def send_message( message, host, port )
        udp_send( message, 0, host, port )
      end

      def type_tag(*args)
        args = *args
        args.collect{ |msg| OSC::Packet.tag( msg ) }.to_s
      end
    end
    $UDP_Sender = UDPSender.instance
    
    class Server
      attr_reader :host, :port
      @@sc_path = '/Applications/SuperCollider/scsynth'
      @@servers = []

      # Initializes and registers a new Server instance and sets the host and port for it.
      # The server is a Ruby representation of scsynth which can be a local binary or a remote    
      # server already running.
      # Server class keeps an array with all the instantiated servers
      def initialize( host = 'localhost', port = 57111)
        @host, @port = host, port
        @@servers << self
      end
      
      # Boots the local binary of the scsynth forking a process, it will rise a SCError if the scsynth 
      # binary is not found in /Applications/SuperCollider/scsynth (default Mac OS path) or given path. 
      # The default path can be overriden using Server.scsynt_path=('path')
      def boot
        raise SCError.new('Scsynth not found in the given path') unless File.exists?( @@sc_path )
        Thread.new do
          path = @@sc_path.scan(/[^\/]+/)
          @server_pipe = IO.popen( "cd /#{ path[0..-2].join('/') }; ./#{ path.last } -u #{ @port }" )
          loop { p Special.new(@server_pipe.gets.chomp) }
        end unless @server_pipe   
        sleep 2 # TODO: There should be a better way to wait for the server to start
        send "/g_new", 1  
        self   
      end
      
      def stop
        send "/g_freeAll", 0
        send "/clearSched"
        send "/g_new", 1
      end
      
      # Sends the /quit OSC signal to the scsynth server and kills the forked process if the scsynth
      # server is running locally
      def quit
        send '/quit'
        Process.kill 'KILL', @server_pipe.pid if @server_pipe
        @server_pipe = nil
      end
      
      # Sends an OSC command to the scsyth server.
      # E.g. <tt>server.send('/dumpOSC', 1)</tt>
      def send( command, *args )
        $UDP_Sender.send( command, @host, @port, *args )
        self
      end
      
      # Encodes and sends a SynthDef to the scsynth server
      def send_synth_def( synth_def )
        *blob = OSC::Blob.new( synth_def.encode ), 0
        def_message = OSC::Message.new( '/d_recv', $UDP_Sender.type_tag( blob ), *blob )
        send_message( OSC::Bundle.new( nil, def_message ) )
      end
      
      private
      def send_message( message ) #:nodoc:
        $UDP_Sender.send_message( message, @host, @port )
      end
      
      public
      class << self
        
        # Specify the scsynth binary path
        def sc_path=( path )
          @@sc_path = path
        end

        # Get the scsynth path
        def sc_path
          @@sc_path
        end
      
        # Returns an array with all the registered servers
        def all
          @@servers
        end
        
        # Clear the servers array
        def clear_servers
          @@servers.clear
        end
      
        # Return a server corresponding to the specified index of the registered servers array
        def [](index)
          @@servers[index]
        end
        
        # Set a server to the specified index of the registered servers array
        def []=(index)
          @@servers[index]
          @@servers.uniq!
        end
      end
      
    end
    
    class SCError < StandardError
    end

  end
end