module Scruby
  # Thread.new do
  #   EventMachine.run do
  #     EM.set_quantum 5
  #     EM.error_handler do |e|
  #       puts e
  #     end
  #   end
  # end

  # A timer will call a given block periodically. The period is specified in beats per minute.
  class Ticker
    attr_reader :start, :tick, :interval
    attr_accessor :tempo, :resolution, :size, :loop

    def initialize(tempo: 120, size: 16, resolution: 1, loop: true, &block)
      @tempo, @resolution, @size, @loop = tempo, resolution, size, loop
      @interval = 60.0 / @tempo
      @tick = 0
      @block = block
    end

    def block(&block)
      @block = block
    end

    def run
      return self if @timer

      @start = Time.now
      @timer = EventMachine::PeriodicTimer.new @interval * 0.01 do
        if @next.nil? or Time.now >= @next
          dispatch
          @tick += @resolution
          next_time
        end
      end
      self
    end

    def index
      return @tick unless @size

      tick = @tick % @size
      if tick == 0 and @tick > 0 and !@loop
        stop
        nil
      else
        tick
      end
    end

    def next_time
      @next = @start + @tick * @interval
    end

    def stop
      @timer&.cancel
      @timer = nil
      @next  = nil
      @tick = 0
      self
    end

    def running?
      !@timer.nil?
    end

    def dispatch
      @block&.call index
    end
  end

  class Scheduler < Ticker
    def initialize(opts = {})
      super
      @queue = []
    end

    def dispatch
      if blocks = @queue[index]
        blocks.each(&:call)
      end
    end

    def at(tick, &proc)
      @queue[tick] ||= []
      @queue[tick].push proc
    end
  end
end
