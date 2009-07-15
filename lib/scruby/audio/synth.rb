module Scruby
  class Synth < Node

    def initialize name, opts = {}
      raise ArgumentError, 'Second argument must be a Hash' unless opts.kind_of? Hash
      super name, opts.delete(:servers)
      @servers.each{ |s| s.send 9, @name, self.id, 0, 1, *opts.to_a.flatten } #Node?
    end

    def set args = {}
      @servers.each{ |s| s.send 15, self.id, *args.to_a.flatten }
      self
    end
    
    def free
      @servers.each{ |s| s.send 9, self.id }
      self
    end

  end
end