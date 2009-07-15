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
    # asUgenInput
    # asControlInput
    # asBufWithValues
    # readMsg { arg argpath, fileStartFrame = 0, numFrames, 
    #         bufStartFrame = 0, leaveOpen = false, completionMessage;
    #   path = argpath;
    #   ^["/b_read", bufnum, path, fileStartFrame, numFrames ? -1, 
    #     bufStartFrame, leaveOpen.binaryValue, completionMessage.value(this)]
    #   // doesn't set my numChannels etc.
    # }
    
    attr_reader   :server
    attr_accessor :path, :frames, :channels, :rate
    
    def initialize server, frames = -1, channels = 1
      @server, @frames, @channels = server, frames, channels
      @server.allocate_buffers self
    end

    def read path, file_start = 0, frames = -1, buf_start = 0, leave_open = false
      message = Message.new "/b_read", bufnum, path, file_start, frames, buf_start, leave_open.to_i# , *Blob.new('/b_query', buf.bufnum)
      self
    end
    
    def allocate &message
      @server.send_message Message.new( '/b_alloc', bufnum, frames, channels, *Blob.new( message.call(self) ) )
    end
    
    def bufnum
      @bufnum ||= @server.buffers.index self
    end

    # :nodoc:
    def allocate_and_read path, start, frames, &completion
      @path = path
      @server.send "/b_allocRead", bufnum# , path, start, frames, yield(self)
      self
    end
    
    class << self
      def read server, path, start = 0, frames = -1, &action
        buffer = new server, &action
        buffer.allocate_and_read( path, start, frames ){ |buf| ["/b_query", buf.bufnum] }
      end
      
      def allocate server, frames = -1, channels = 1
        buffer = new server, frames, channels
        # buffer.rate = server.rate
        buffer.alloc
      end
      
      named_arguments_for :read
     
      # alloc
      # allocConsecutive
      # readChannel
      # readNoUpdate
      # cueSoundFile
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
    