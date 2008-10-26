require 'rexml/document'
require 'yaml'
include REXML


dir = File.expand_path(File.dirname(__FILE__))
file = File.new File.join( dir, 'ugendefs.xml')
# p file.read
doc = Document.new( file )


ugens = {}

doc.root.each_element('ugen') do |e|
  klass = e.attribute(:class).value

  rates = {}
  
  e.attribute(:rates).value.scan(/\w+/).each do |r|
    args = []
    
    e.each_element('arg')  do |a|
      name  = a.attribute( :name ).value.to_sym
      begin
        value = a.attribute( :def ).value.to_f
      rescue
        value = nil
      end
      args << [name, value].dup
    end

    

    rates[r.to_sym] = Array.new(args)
  end

  ugens[klass] = rates
end

puts u = ugens.to_yaml


file = File.new("#{dir}/ugen_defs.yaml", "w")
file.write( u )
file.close




