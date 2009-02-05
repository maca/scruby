module Scruby
  class Node
    @@base_id = 2000
    attr_reader :name, :servers

    def initialize( name, *servers )
      @name = name.to_s
      servers  = *servers
      @servers = servers ? TypedArray.new( Server, [*servers] ) : Server.all
    end

    def id
      @id ||= ( @@base_id = @@base_id + 1 )
    end

    def self.reset!
      @@base_id = 2000
    end
  end
end