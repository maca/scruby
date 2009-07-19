module Scruby
  class Buffer
    # allocReadChannel
    # allocReadMsg
    # alloc ReadCannelMsg
    # read
    # readChannel
    # readNoUpdate
    # readMsg
    # readChannelMsg
    # cueSoundFile
    # cueSoundFilMsg
    # loadCollection
    # sendCollection
    # streamCollection
    # loadToFloatArray
    # getToFloatArray
    # write
    # writeMsg
    # free
    # zero
    # zeroMsg
    # set
    # setMsg
    # setn
    # setnMsgArgs
    # setnMsg
    # get
    # getMsg
    # getn
    # getnMsg
    # fill
    # fillMsg
    # normalize
    # gen
    # genMsg
    # sine1
    # ...
    # copy
    # copyData
    # copyMsg
    # close
    # closeMsg
    # query
    # updateInfo
    # cache
    # uncache
    # queryDone
    # printOn
    # play
    # duration


    # asBufWithValues

    
    attr_reader   :server
    attr_accessor :path, :frames, :channels, :rate
    
    def initialize server, frames = -1, channels = 1
      @server, @frames, @channels = server, frames, channels
      @server.allocate_buffers self
    end

    def allocate &message
      message ||= 0
      @server.send '/b_alloc', buffnum, frames, channels, message.value(self)
      self
    end

    def buffnum
       @server.buffers.index self
    end
    alias :as_ugen_input :buffnum
    # alias :as_control_input :buffnum

    # :nodoc:
    def allocate_and_read path, start, frames, &message
      message ||= ["/b_query", buffnum]
      @server.send "/b_allocRead", buffnum, @path = path, start, frames, message.value(self)
      self
    end
    
    class << self
      # Allocate a buffer and immediately read a soundfile into it.
      def read server, path, start = 0, frames = -1, &message
        buffer = new server, &message
        buffer.allocate_and_read path, start, frames
      end
      
      def cue_sound_file server, path, start, channels = 2, buff_size = 32768, &message
        allocate server, buff_size, channels do |buffer|
          message ||= 0
          ['/b_read', buffer.buffnum, path, start, buff_size, 0, true, message.value(buffer)]
        end
      end
      
      def allocate server, frames = -1, channels = 1, &message
        buffer = new server, frames, channels
        buffer.allocate &message
      end
      
      named_arguments_for :allocate, :read, :cue_sound_file
     
      # allocConsecutive
      # readChannel
      # readNoUpdate
      # loadCollection
      # sendCollection
      # freeAllinitServerCache
      # initServerCache
      # clearServerCaches
      # cachedBuffersDo
      # cachedBufferAt
      # loadDialog
    end
  end
end
    