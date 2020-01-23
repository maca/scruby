module Scruby
  def expand_path(path)
    File.expand_path path
  end

  class Buffer
    # readNoUpdate
    # loadCollection
    # sendCollection
    # streamCollection
    # loadToFloatArray
    # getToFloatArray
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
    # query
    # updateInfo
    # queryDone
    # printOn
    # play
    # duration
    # asBufWithValues

    attr_reader   :server
    attr_accessor :path, :frames, :channels, :rate

    def read(path, file_start: 0, frames: -1, buff_start: 0,
             leave_open: false, &message)

      # @on_info  = message
      message ||= [ "/b_query", buffnum ]

      @server.send "/b_read", buffnum, expand_path(path), file_start,
                   frames, buff_start, leave_open, message.value(self)
      self
    end

    def read_channel(path, _file_start: 0, frames: -1, buff_start: 0,
                     leave_open: false, channels: [], &message)

      message ||= 0

      @server.send *([ "/b_ReadChannel", buffnum, expand_path(path), start, frames, buff_start, leave_open ] + channels << message.value(self))
      self
    end

    def close(&message)
      message ||= 0
      @server.send "/b_close", buffnum, message.value(self)
      self
    end

    def zero(&message)
      message ||= 0
      @server.send "/b_zero", buffnum, message.value(self)
      self
    end

    def cue_sound_file(path, start: 0, &message)
      message ||= 0
      @server.send "/b_read", buffnum, expand_path(path), start, @frames,
                   0, 1, message.value(self)
      self
    end

    def write(path, format: "aiff", sample_format: "int24", frames: -1,
              start: 0, leave_open: false, &message)

      message ||= 0
      path    ||= "#{ DateTime.now }.#{ format }"
      @server.send "/b_write", buffnum, expand_path(path), format, sample_format, frames, start, leave_open, message.value(self)
      self
    end

    def initialize(server: nil, frames: -1, channels: 1)
      @server, @frames, @channels = server, frames, channels
    end

    def allocate(&message)
      message ||= 0
      @server.allocate :buffers, self
      @server.send "/b_alloc", buffnum, frames, channels, message.value(self)
      self
    end

    def buffnum
      @server.buffers.index self
    end
    alias index         buffnum
    # alias :as_control_input :buffnum

    def free(&message)
      message ||= 0
      @server.send "/b_free", buffnum, message.value(self)
      @server.buffers.delete self
    end

    # :nodoc:
    def allocate_and_read(path, start, frames, &message)
      @server.allocate :buffers, self
      message ||= [ "/b_query", buffnum ]
      @server.send "/b_allocRead", buffnum, @path = expand_path(path), start, frames, message.value(self)
      self
    end

    def allocate_read_channel(path, start, frames, channels, &message)
      @server.allocate :buffers, self
      message ||= [ "/b_query", buffnum ]
      @server.send *([ "/b_allocReadChannel", buffnum, expand_path(path), start, frames ] + channels << message.value(self))
      self
    end

    class << self
      def allocate(server, frames: -1, channels: 1, &message)
        new(server, frames, channels).allocate &message
      end

      def cue_sound_file(server, path, start, channels: 2, buff_size: 32_768, &message)
        allocate server, buff_size, channels do |buffer|
          message ||= 0
          [ "/b_read", buffer.buffnum, expand_path(path), start, buff_size, 0, true, message.value(buffer) ]
        end
      end

      # Allocate a buffer and immediately read a soundfile into it.
      def read(server, path, start: 0, frames: -1, &message)
        buffer = new server, &message
        buffer.allocate_and_read expand_path(path), start, frames
      end

      def read_channel(server, path, start: 0, frames: -1, channels: [], &message)
        new(server, frames, channels).allocate_read_channel expand_path(path), start, frames, channels, &message
      end

      def alloc_consecutive(buffers, server, frames: -1, channels: 1, &message)
        buffers = Array.new(buffers){ new server, frames, channels }
        server.allocate :buffers, buffers
        message ||= 0
        buffers.each do |buff|
          server.send "/b_alloc", buff.buffnum, frames, channels, message.value(buff)
        end
      end

      # readNoUpdate
      # loadCollection
      # sendCollection
      # loadDialog
    end
  end
end
