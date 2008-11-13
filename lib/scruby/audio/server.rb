module Scruby 
  module Audio
    class Server < OSC::UDPServer
      attr_reader :host, :port
      @@sc_path = '/Applications/SuperCollider/scsynth'

      def initialize( host = 'localhost', port = 57110)
        @host, @port = host, port
      end

      alias :udp_send :send
      def send( command, *args )
        udp_send( OSC::Message.new( command, type_tag(args), *args ), 0, @host, @port )
      end

      def send_message( message )
        udp_send( message, 0, @host, @port )
      end
      
      def type_tag(*args)
        args = *args
        args.collect{ |msg| OSC::Packet.tag( msg ) }.to_s
      end
      
      def send_synth_def( synth_def )
    		*blob = OSC::Blob.new( synth_def.encode ), 0
    		def_message = OSC::Message.new( '/d_recv', type_tag( blob ), *blob )
    		self.send_message( OSC::Bundle.new( nil, def_message ) )
    	end
    	
    	def stop
  	  end
  	  
  	  def boot
  	    raise SCError.new('Scsynth not found in the given path') unless File.exists?( @@sc_path )
	    end
    	
    	class << self
    	  def sc_path=( path )
    	    @@sc_path = path
  	    end
  	    
  	    def sc_path
  	      @@sc_path
  	    end
  	  end  	  
      
      class SCError < StandardError
      end
    end
  
  end
end