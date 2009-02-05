module Scruby
  class Synth < Node

    def initialize( name, opts = {} )
      super( name, opts.delete(:servers) )
      @servers.each{ |s| s.send '/s_new', *([@name, self.id, 0, 1] + opts.to_a.flatten) }
    end

    def set( args = {} )
      @servers.each{ |s| s.send '/n_set', *([self.id] + args.to_a.flatten) }
      self
    end

  end
end