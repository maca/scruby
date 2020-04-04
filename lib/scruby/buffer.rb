module Scruby
  class Buffer
    include OSC
    include Concurrent

    attr_reader :server, :frames, :channel_count, :path, :start_frame,
                :sample_rate

    def initialize(server)
      @server = server
    end

    def id
      @id ||= server.next_buffer_id
    end

    def duration
      return 0 if sample_rate.nil?
      frames.to_i / sample_rate
    end

    def alloc(*args, &block)
      perform(alloc_async(*args), &block)
    end

    def alloc_async(frames, channel_count = 1)
      apply("/b_alloc", id, frames, channel_count)
    end

    def alloc_read(path, *args, &block)
      perform(alloc_read_async(path, *args), &block)
    end

    def alloc_read_async(path, range = (0..-1))
      path = File.expand_path(path)
      from, to = range.first, range.last

      apply("/b_allocRead", id, path, from, to)
    end

    def close(&block)
      perform(close_async, &block)
    end

    def close_async
      apply("/b_close", id)
    end

    def copy_data(*args, &block)
      perform(copy_data_async(*args), &block)
    end

    def copy_data_async(dest, dest_at = 0, range = (0..-1))
      from, source_to = range.first, range.last

      apply("/b_gen", dest.id, "copy", dest_at, id, from, source_to)
    end

    def play(loop = false)
      player =
        PlayBuf.ar(channel_count, id, BufRateScale.kr(id), loop: loop)

      return player.play(server) if loop
      player.build_graph.add(FreeSelfWhenDone.kr(player)).play(server)
    end


    # def read(path, file_start_frame: 0, start_frame: 0,
    #          frames: -1, leave_open: false, action: nil)
    #   path = File.expand_path(path)
    #   start_frame = start_frame
    #   server.send_msg(
    #     "/b_read",
    #     id, path, file_start_frame, frames, start_frame, leave_open
    #   )
    # end

    # alloc_read_channel

    # write
    # free
    # set
    # setn
    # get
    # getn
    # fill
    # normalize
    # gen

    # sine1
    # sine2
    # cheby

    def query
      send_query.then { |ary|
        %i(id frames channel_count sample_rate).zip(ary).to_h
      }.value!
    end

    private

    def send_query
      server
        .send_msg("/b_query", id)
        .receive { |m| m.address == "/b_info" && m.args.first == id }
        .then(&:args)
    end

    def update
      send_query
        .then { |a| _, @frames, @channel_count, @sample_rate = a }
    end

    def apply(action, *args)
      server
        .send_msg(action, *args)
        .receive(&curry(:match_alloc_reply, action, id))
        .then { update }.flat_future
        .then { self }
    end

    def match_alloc_reply(action, id, msg, future)
      case msg.to_a
      in [ "/fail", ^action, error, ^id ]
        future.reject Server::Error.new(error)
      in [ "/done", ^action, ^id ]
        true
      end
    end

    def perform(future, &block)
      future.then(&(block || :itself)).value!
    end

    def curry(name, *args)
      method(name).to_proc.curry[*args]
    end

    class << self
      def alloc(server, **args)
        new(server, **args).alloc
      end
    end
  end
end
