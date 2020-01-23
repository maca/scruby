module Scruby
  class Bus
    attr_reader :server, :rate, :channels, :main_bus

    def initialize(server, rate, channels = 1, main_bus = self, hardware_out = false)
      @server, @rate, @channels, @main_bus, @hardware_out = server, rate, channels, main_bus, hardware_out
    end

    def index
      @index ||= @server.__send__("#{ @rate }_buses").index(self)
    end

    def free
      @index = nil
      @server.__send__("#{ @rate }_buses").delete(self)
    end

    def to_map
      raise SCError, "Audio buses cannot be mapped" if rate == :audio

      "c#{ index }"
    end

    def audio_out?
      index < @server.instance_variable_get(:@opts)[:audio_outputs]
    end

    # Messaging
    def set(*args)
      args.flatten!
      message_args = []
      (index...channels).to_a.zip(args) do |chan, val|
        message_args.push(chan).push(val) if chan and val
      end
      if args.size > channels
        warn "You tried to set #{ args.size } values for bus #{ index } that only has #{ channels } channels, extra values are ignored."
      end
      @server.send "/c_set", *message_args
    end

    def fill(value, channels = @channels)
      if channels > @channels
        warn "You tried to set #{ channels } values for bus #{ index } that only has #{ @channels } channels, extra values are ignored."
      end
      @server.send "/c_fill", index, channels.min(@channels), value
    end

    class << self
      private :new

      def control(server, channels = 1)
        buses = [ new(server, :control, channels) ]
        buses.push new(server, :control, channels, buses.first) while buses.size < channels
        server.allocate :control_buses, buses
        buses.first
      end

      def audio(server, channels = 1)
        buses = [ new(server, :audio, channels) ]
        buses.push new(server, :audio, channels, buses.first) while buses.size < channels
        server.allocate :audio_buses, buses
        buses.first
      end
    end
  end
end
