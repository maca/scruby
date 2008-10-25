module Scruby
  module Audio
    module Ugens
      UGEN_DEFS = YAML::load( File.open( "#{LIB_DIR}/audio/ugens/ugen_defs.yaml" ) )
      
      module Instantiation
        def ar( *args )
        end
        
        def kr( *args )
        end
      end
      
      def self.define_ugen(name, args)
        self.module_eval("class #{name} < Ugen; end")
        klass = eval(name)
        klass.send :extend, Instantiation
        klass
      end
      
      UGEN_DEFS.each_pair do |key, value|
        self.define_ugen(key, value)
      end

    end
  end
end
