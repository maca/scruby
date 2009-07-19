module Scruby
  class Buffer
    

    # read
    # readChannel
    # readNoUpdate
    # cueSoundFile
    # loadCollection
    # sendCollection
    # streamCollection
    # loadToFloatArray
    # getToFloatArray
    # write
    # writeMsg
    # zero
    # set
    # setn
    # get
    # getn
    # fill
    # normalize
    # gen
    # sine1
    # ...
    # copy
    # copyData
    # close
    # query
    # updateInfo
    # queryDone
    # printOn
    # play
    # duration
    # asBufWithValues

    attr_reader   :server
    attr_accessor :path, :frames, :channels, :rate
    
    def initialize server, frames = -1, channels = 1
      @server, @frames, @channels = server, frames, channels
    end

    def allocate &message
      message ||= 0
      @server.allocate_buffers self
      @server.send '/b_alloc', buffnum, frames, channels, message.value(self)
      self
    end

    def buffnum
       @server.buffers.index self
    end
    alias :as_ugen_input :buffnum
    # alias :as_control_input :buffnum
    
    def free &message
      message ||= 0
      @server.send "/b_free", buffnum, message.value(self)
      @server.buffers.delete self
    end

    # :nodoc:
    def allocate_and_read path, start, frames, &message
      @server.allocate_buffers self
      message ||= ["/b_query", buffnum]
      @server.send "/b_allocRead", buffnum, @path = path, start, frames, message.value(self)
      self
    end
    
    def allocate_read_channel path, start, frames, channels, &message
      @server.allocate_buffers self
      message ||= ["/b_query", buffnum]
      @server.send *(["/b_allocReadChannel", buffnum, path, start, frames] + channels << message.value(self))
      self
    end
    
    class << self
      def allocate server, frames = -1, channels = 1, &message
        new(server, frames, channels).allocate &message
      end
      
      def cue_sound_file server, path, start, channels = 2, buff_size = 32768, &message
        allocate server, buff_size, channels do |buffer|
          message ||= 0
          ['/b_read', buffer.buffnum, path, start, buff_size, 0, true, message.value(buffer)]
        end
      end
      
      # Allocate a buffer and immediately read a soundfile into it.
      def read server, path, start = 0, frames = -1, &message
        buffer = new server, &message
        buffer.allocate_and_read path, start, frames
      end
      
      def read_channel server, path, start = 0, frames = -1, channels = [], &message
        new(server, frames, channels).allocate_read_channel path, start, frames, channels, &message
      end
      
      def alloc_consecutive buffers, server, frames = -1, channels = 1, &message
        buffers = Array.new(buffers){ new server, frames, channels }
        server.allocate_buffers buffers
        message ||= 0
        buffers.each do |buff|
          server.send '/b_alloc', buff.buffnum, frames, channels, message.value(buff)
        end
      end
      
      # def send_collection server, collection, channels = 1, wait = 0.0, &message
      # end
      named_arguments_for :allocate, :read, :cue_sound_file, :alloc_consecutive, :read_channel

      # readNoUpdate
      # loadCollection
      # sendCollection
      # loadDialog
    end
  end
end
    