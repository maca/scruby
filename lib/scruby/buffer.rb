module Scruby
  class Buffer
    include OSC

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

    def alloc_read_async(path, from = 0, to = -1)
      path = File.expand_path(path)
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

    def copy_data_async(dest, dest_start = 0, src_start = 0,
                        samples = -1)

      apply("/b_gen", dest.id, "copy", dest_start, id,
            src_start, samples)
    end

    def read(*args, &block)
      perform(read_async(*args), &block)
    end

    def read_async(path, file_start_frame = 0, frames = -1,
                   buf_start_frame = 0, leave_open = false)

      apply("/b_read", id, File.expand_path(path),
            file_start_frame, frames, buf_start_frame, leave_open)
    end

    def play(loop = false)
      rate = BufRateScale.kr(id)
      player = PlayBuf.ar(channel_count, id, rate, loop: loop)

      return player.play(server) if loop
      player.build_graph.add(FreeSelfWhenDone.kr(player)).play(server)
    end

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
      send_query.then { |m|
        %i(id frames channel_count sample_rate).zip(m.args).to_h
      }.value!
    end

    private

    def send_query
      server
        .send_msg("/b_query", id)
        .receive("/b_info") { |m| m.args.first == id }
    end

    def update
      send_query
        .then { |m| _, @frames, @channel_count, @sample_rate = m.args }
    end

    def apply(action, *args)
      server
        .send_msg(action, *args)
        .receive(&curry(:match_alloc_reply, action, id))
        .then_flat_future { update }
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
