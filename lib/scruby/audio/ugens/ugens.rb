module Scruby
  module Audio
    module Ugens
      ugen_defs = YAML::load( File.open( "#{LIB_DIR}/audio/ugens/ugen_defs.yaml" ) )
      
      def self.define_ugen(name, rates)
        rate_name = {:audio => :ar, :control => :kr, :scalar => :ir, :demand => :new}
        rates.delete_if{ |key, value| key == :demand  } #I don't know what to do with these
        
        klass = "class #{name} < Ugen\n" +
        rates.collect do |r|
            new_args = ( [r.first] + r.last.collect{|a|a.first} ).join(', ')
            args = (r.last + [[:mul,1],[:add,0]]).collect{ |a| a.compact.join(' = ')}.join(', ')
            " def self.#{rate_name[r.first]}(#{args})\n" +
            "   new(:#{new_args}).muladd(mul, add)" + 
            "\n end"
        end.join("\n\n") + "\nend\n\n"

        unless %w(InRect TWindex RecordBuf BufWr ScopeOut).include?(name)
          self.class_eval klass
          klass = eval(name)
          methods = rates.collect{ |r| ":#{rate_name[r.first]}" }.join(', ')
          self.class_eval "class #{name}; class << self; named_args_for #{methods}; end; end;"
        end
      end
      
      ugen_defs.each_pair do |key, value|
        self.define_ugen(key, value)
      end

    end
  end
end
