require 'tempfile'
require 'rubygems'
require 'highline'
require 'parse_tree'
require 'ruby2ruby'

module Kernel
  alias :l :lambda
  
  # Calls Kernel#eval with the given args but catches posible errors
  def resilient_eval( *args )
    begin
      begin
        eval( *args )
      rescue SyntaxError => e
        e
      end
    rescue => e
      e
    end
  end
  
  def p( obj ) #:nodoc:
    puts obj.to_live_output
  end

end

class Object
  
  # Outputs an ANSI colored string with the object representation
  def to_live_output
    case self
    when Exception
      "\e[41m\e[33m#{self.inspect}\e[0m"
    when Numeric, Symbol, TrueClass, FalseClass, NilClass
      "\e[35m#{self.inspect}\e[0m"
    when Notice
      "\e[42m\e[30m#{self}\e[0m"
    when Warning
      "\e[43m\e[30m#{self}\e[0m" 
    when Special
      "\e[44m\e[37m#{self}\e[0m" 
    when String
      "\e[32m#{self.inspect}\e[0m"
    when Array
      "[#{ self.collect{ |i| i.to_live_output}.join(', ') }]"
    when Hash
      "{#{ self.collect{ |i| i.collect{|e| e.to_live_output}.join(' => ') } }}"
    else
      "\e[36m#{self}\e[0m"
    end
  end
end

class Notice < String; end
class Warning < String; end
class Special < String; end

module Live 
  class Pipe < Tempfile 
    def make_tmpname( *args ) 
      "ruby_live.pipe"
    end
  end
  
  class Session
    include HighLine::SystemExtensions
    
    # Starts a live session using a named pipe to receive code from a remote source and evaluates it within a context, a bit like an IRB session but evaluates code sent from a text editor
    def initialize 
      return p( Exception.new("Another session sems to be running") ) if File.exist?( "#{Dir.tmpdir}/ruby_live.pipe" )
      p( Notice.new("Live Session") )
      get_binding
      init_pipe
      expect_input
      serve
    end
    
    def init_pipe
      @pipe_path = Pipe.new('').path
      `rm #{@pipe_path}; mkfifo #{@pipe_path}`
    end
    
    # Starts a loop that checks the named pipe and evaluate its contents, will be called on initialize
    def serve 
      File.open( @pipe_path, File::RDONLY | File::NONBLOCK) do |f|
        loop { p evaluate( f.gets.to_s.gsub("∂", "\n") ) }
      end
    end
  
    # Starts a new Thread that will loop capturing keystrokes and evaluating the bound block within the @context Binding, will be called on initialize
    def expect_input 
      Thread.new do
        loop do 
          char = get_character 
          @bindings ||= []
          bind = @bindings[ char ]
          p evaluate( bind ) if bind 
        end
      end
    end
    
    # Expects a one char Symbol or String which will bind to a passed block so it can be called later with a keystroke
    def bind( key, &block ) 
      @bindings = [] unless @bindings.instance_of?(Array)
      block ||= Proc.new{}
      @bindings[ key.to_s[0] ] = Ruby2Ruby.new.process( [:block, block.to_sexp.last] )
      Notice.new( "Key '#{key}' is bound to an action")
    end
    
    # Evaluates a ruby expression within the @context Binding
    def evaluate( string = nil ) 
      return resilient_eval( string, @context ) if string
    end
    
    def clear
      print "\e[2J\e[f"
    end
    
    def get_binding #:nodoc:
      @context = binding
    end
    
    def run_updates( code )
      source = ParseTree.new.parse_tree_for_string( code ).first
      final = []
      while iter = source.assoc(:iter)
        source -= [iter]
        final << [:block, iter.last] if iter[1].include?(:update)
      end
      evaluate( final.collect{ |exp| Ruby2Ruby.new.process(exp) }.join("\n") )
      Notice.new('Update blocks evaluated')
    end
    
    def update # Allmost a stub
      yield
    end
    
    alias :reaload! :get_binding
  end
end


