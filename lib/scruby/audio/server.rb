require 'singleton'

module Scruby 
  module Audio

    class UDPServer < OSC::UDPServer
      include Singleton

      alias :udp_send :send
      def send( command, host, port, *args )
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
    
    $UDP_SERVER = UDPServer.instance
    
    class Server
      attr_reader :host, :port
      @@sc_path = '/Applications/SuperCollider/scsynth'

      def initialize( host = 'localhost', port = 57110)
        @host, @port = host, port
      end
      
      def boot
        raise SCError.new('Scsynth not found in the given path') unless File.exists?( @@sc_path )
        Thread.new do
          path = @@sc_path.scan(/[^\/]+/)
          @synth = IO.popen( "cd /#{ path[0..-2].join('/') }; ./#{ path.last } -u #{ @port }" ) do |f|
            loop do 
              p Special.new( f.gets.chomp ) 
            end
          end
        end
      end
      
      def stop
        send('/quit')
        @synth = nil 
      end
      
      def send( command, *args )
        return $UDP_SERVER.send( command, @host, @port, *args )
      end
      
      def send_synth_def( synth_def )
        *blob = OSC::Blob.new( synth_def.encode ), 0
        def_message = OSC::Message.new( '/d_recv', $UDP_SERVER.type_tag( blob ), *blob )
        send_message( OSC::Bundle.new( nil, def_message ) )
        return synth_def
      end
      
      def self.sc_path=( path )
        @@sc_path = path
      end

      def self.sc_path
        @@sc_path
      end
      
      private
      def send_message( message )
        return $UDP_SERVER.send_message( message, @host, @port ) if @synth
      end
    end
    
    class SCError < StandardError
    end

  end
end