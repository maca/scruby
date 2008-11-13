module Scruby
  module Audio
    module Ugens
      ugen_defs = YAML::load( File.open( "#{LIB_DIR}/audio/ugens/ugen_defs.yaml" ) )
      putc 'Loading ugen definitions'
      
      def self.define_ugen(name, rates)
        putc '.'
        rate_name = {:audio => :ar, :control => :kr, :scalar => :ir, :demand => :new}
        rates.delete_if{ |key, value| key == :demand  } #I don't know what to do with these
        
        methods = rates.collect{ |r| ":#{rate_name[r.first]}" }.join(', ')
        
        klass = "class #{name} < Ugen\nclass << self\n" +
        rates.collect do |r|
            new_args = ( [r.first] + r.last.collect{|a|a.first} ).join(', ')
            args = (r.last + [[:mul,1],[:add,0]]).collect{ |a| a.compact.join(' = ')}.join(', ')
            " def #{rate_name[r.first]}(#{args})\n" +
            "   new(:#{new_args}).muladd(mul, add)" + 
            "\n end"
        end.join("\n") + "\nnamed_args_for #{methods}\nend\nend\n"

        self.class_eval klass
      end
      
      ugen_defs.each_pair do |key, value|
        self.define_ugen(key, value)
      end

    end
  end
end