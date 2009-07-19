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
      attr_reader :host, :port, :path, :buffers

      # Initializes and registers a new Server instance and sets the host and port for it.
      # The server is a Ruby representation of scsynth which can be a local binary or a remote    
      # server already running.
      # Server class keeps an array with all the instantiated servers
      def initialize host = 'localhost', port = 57111, path = '/Applications/SuperCollider/scsynth'
        @host       = host
        @port       = port
        @path       = path
        @buffers    = []
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
      
      # Encodes and sends a SynthDef to the scsynth server
      def send_synth_def synth_def
        send Bundle.new( nil, Message.new( '/d_recv', Blob.new(synth_def.encode), 0 ) )
      end

      # This method should not be directly called, it will add passed +buffers+ to the @buffers array, the +Buffer#buffnum+
      # will be it's index in this array. Max number of buffers is 1024.
      # It will try to fill first consecutive nil indices of the array and if there are not enough consecutive nil indices for the +buffers+ 
      # passed and the maximum number is not reached it will push the buffers to the array, otherwise will raise an error.
      def allocate_buffers *buffers
        buffers.peel!
        if @buffers.compact.size + buffers.size > 1024 
          raise SCError, 'No more buffer numbers -- free some buffers before allocating more.'
        end
        
        return @buffers += buffers unless @buffers.index nil # just concat arrays if no nil item in @buffers
        
        indices = []
        @buffers.each_with_index do |item, index| # find n number of consecutive nil indices
          break if indices.size >= buffers.size
          if item.nil?
            indices << index
          else
            indices.clear
          end
        end
        
        case 
        when indices.size >= buffers.size
          @buffers[indices.first, buffers.size] = buffers
        when @buffers.size + buffers.size <= 1024
          @buffers += buffers
        else
          raise SCError, "No block of #{ buffers.size } consecutive buffer slots is available."
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