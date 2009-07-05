#!/usr/bin/env ruby
require 'tempfile'

STDOUT.sync = true

class Object
  def to_output
    output( self.inspect )
  end
  
  def output( string )
    "\e[32m#{string}\e[0m"
  end
  
  def to_error
    error( self )
  end
  
  def error( string )
    "\e[41m\e[33m#{string}\e[0m"
  end
end

module LiteralColor
  def output( string )
    "\e[35m#{string}\e[0m"
  end
end

class Numeric
  include LiteralColor
end

class Symbol
  include LiteralColor
end

class TrueClass
  include LiteralColor
end

class FalseClass
  include LiteralColor
end

class NilClass
  include LiteralColor
end
  
class LivePipe < Tempfile
  def make_tmpname( *args )
    "ruby_live.pipe"
  end
end

path = LivePipe.new('').path
`rm #{path}; mkfifo #{path}`

@context = lambda{ binding }.call
File.open( path, File::RDONLY | File::NONBLOCK) do |f|
  while true
    begin
      if f.gets
        puts eval($_, @context).to_output
      end
    rescue => e
      puts e.to_error
    end
    sleep 0.005
  end
end


