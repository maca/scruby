require 'rubygems'
require 'ruby2ruby'


module NamedArgs
  
  module ExtendMethods
    def named_args_for( *methods )
      methods.each do | m |
        unbound   = instance_method( m )
        defaults  = NamedArgs.assign_defaults_string( unbound )

        args = unbound.arg_names.join(',')
        
        hacked_method = "def #{m}_hacked( *args );" + 
          unless args.empty?
            "opts = args.pop if args.last.instance_of?(Hash);" + args + "=args;" + "eval(NamedArgs.assign_options_string(opts));" + defaults
          else
            ''
          end +
          "#{m}_original(" + args + ");" +
        "end"
        
        
                        
        self.class_eval hacked_method

        alias_method "#{m}_original", m
        alias_method m, "#{m}_hacked"
      end
    end
  end
  
  class << self
    def included( klass ) 
      klass.send( :extend, ExtendMethods )
    end
    
    def assign_options_string( hash )
      assign_opts = [:block] + hash.to_a.collect{ |e| [:lasgn, e.first, [:lit, e.last]] }
      Ruby2Ruby.new.process assign_opts
    end

    def assign_defaults_string( method )
      args, assigns = method.args.partition{ |t| t.instance_of?(Symbol)  }
      assigns = *assigns
      return '' unless assigns
      assign_block = [:block] + assigns.select{ |e| e.instance_of?(Array) }.collect{ |e| [:if, [:lvar, e[1]], nil, e] }
      Ruby2Ruby.new.process assign_block
    end
  end
  
  
end

class UnboundMethod
  def to_sexp
    name = ProcStoreTmp.new_name
    ProcStoreTmp.send(:define_method, name, self)
    ProcStoreTmp.new.method(name).to_sexp
  end
  
  def args
    self.to_sexp.assoc(:dmethod).assoc(:scope).assoc(:block).assoc(:args)[1..-1]
  end
  
  def arg_names
    self.args.select{ |i| i.instance_of?(Symbol) }
  end
end

class Object
  include NamedArgs
end
