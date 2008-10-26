require File.join( File.expand_path(File.dirname(__FILE__)),"helper")
require "#{LIB_DIR}/named_args"
require 'benchmark'


class A
  def test(uno = 1, dos = 2, tres = 3, cuatro = 4, cinco = 5, seis = 6, siete = 7, ocho = 8, nueve = 9, diez = 10, once = 11, doce = 12, trece = 13, catorce = 14, quince = 15, dieciseis = 16)
  end
end

class B
  def test(uno = 1, dos = 2, tres = 3, cuatro = 4, cinco = 5, seis = 6, siete = 7, ocho = 8, nueve = 9, diez = 10, once = 11, doce = 12, trece = 13, catorce = 14, quince = 15, dieciseis = 16)
  end
  named_args_for :test
end

describe NamedArgs do

  before :all do
    Klass = nil
  end

  before :each do
    Object.send(:remove_const, 'Klass') 
    class Klass; 
      def zero
      end

      def three( uno = 1, dos = 2, tres = 3 )
      end
      
      def six( uno = 1, dos = 2, tres = 3, cuatro = 4, cinco = 5, seis = 6)
      end
      
      class << self
      def dos( uno = 1, dos = 2)
      end
      named_args_for :dos
      end
    end
    @unbound = mock('unbound', :args => [], :arg_names => [] )
  end

  describe 'inclusion' do

    it 'should include Named args' do
      # Klass.send( :include, NamedArgs )
      Klass.included_modules.should include(NamedArgs)
    end

    it "should extend ExtendMethods" do
      Klass.should_receive(:extend).with(NamedArgs::ExtendMethods)
      Klass.send( :include, NamedArgs )
    end

    it do
      Klass.send( :include, NamedArgs )
      Klass.should respond_to(:named_args_for)
    end

    it 'should receive #instance_method with :three' do
      Klass.should_receive( :instance_method ).with( :three ).and_return( @unbound )
      Klass.send( :include, NamedArgs )
      Klass.send( :named_args_for, :three )
    end

    it 'should receive #instance_method with :zero and :three' do
      Klass.should_receive( :instance_method ).with( :zero ).and_return( @unbound )
      Klass.should_receive( :instance_method ).with( :three ).and_return( @unbound )
      Klass.send( :include, NamedArgs )
      Klass.send( :named_args_for, :zero, :three )
    end

    it do
      NamedArgs.should respond_to(:assign_options_string)
      NamedArgs.should respond_to(:assign_defaults_string)
    end
    
    it do
      Klass.should_receive( :instance_method ).with( :three ).and_return( @unbound )
      Klass.should_receive( :instance_method ).with( :zero ).and_return( @unbound )
      @unbound.should_receive(:args).twice.and_return([])
      @unbound.should_receive(:arg_names).twice.and_return([])
      Klass.send( :include, NamedArgs )
      Klass.send( :named_args_for, :zero, :three )
    end
  end

  describe '#named_args_for' do

    before do
      Klass.send( :include, NamedArgs )
    end
    
    it do
      Klass.send( :named_args_for, :three )
      Klass.new.should respond_to( :three_original )
    end
    
    it do
      Klass.send( :named_args_for, :three )
      Klass.new.should respond_to( :three_hacked )
    end

  end
  
  describe '#hacked_method' do
    
    before do
      Klass.send( :include, NamedArgs )
      Klass.send( :named_args_for, :zero, :three, :six )
      @instance = Klass.new
    end
    
    it do
      @instance.should_receive(:three_original).with(1,2,3)
      @instance.three(1,2,3)
    end
    
    it do
      @instance.should_receive(:three_original).with(1,2,3)
      @instance.three
    end
    
    it do
      @instance.should_receive(:three_original).with(1,2,2)
      @instance.three(1,2,2)
    end
    
    it do
      @instance.should_receive(:three_original).with(:a,:b,:c)
      @instance.three(:uno => :a, :dos => :b, :tres => :c)
    end
    
    it do
      @instance.should_receive(:three_original).with(:a,:b,:c)
      @instance.three(1, 2, 3, :uno => :a, :dos => :b, :tres => :c)
    end
    
    it do
      @instance.should_receive(:three_original).with(:a,:b,:c)
      @instance.three(1, 2, 3, :uno => :a, :dos => :b, :tres => :c)
    end
    
    it do
      @instance.should_receive(:six_original).with(1,:a,3,:b,5,:c)
      @instance.six(:dos => :a, :cuatro => :b, :seis => :c)
    end
    
    it do
      @instance.should_receive(:zero_original).with()
      @instance.zero
    end
  
  end
  
  describe NamedArgs do
    
    it "should get assign_defaults_string" do
      NamedArgs.assign_defaults_string( Klass.instance_method(:zero) ).should == ""
      NamedArgs.assign_defaults_string( Klass.instance_method(:three) ).should == "uno = 1 unless uno\ndos = 2 unless dos\ntres = 3 unless tres\n"
    end
    
    it "should assign from hash" do
      NamedArgs.assign_options_string( {:uno => 1, :dos => 2, :tres => 3} ).should =~ /uno = 1/
      NamedArgs.assign_options_string( {:uno => 1, :dos => 2, :tres => 3} ).should =~ /dos = 2/
      NamedArgs.assign_options_string( {:uno => 1, :dos => 2, :tres => 3} ).should =~ /tres = 3/
    end
    
  end
  
  describe 'Class methods' do
    
    it do
      Klass.should_receive(:dos_original)
      Klass.dos
    end
    
  end 
end


describe 'benchmark' do
  before :all do
    @a = A.new
    @b = B.new
  end

  it do
    @b.should_receive(:test_original).with(1,2,3,4,5,6,7,8,9,10,11,12,13,14,:a,:b)
    @b.test(:quince => :a, :dieciseis => :b)
  end

  it do
    Benchmark.bm do |x|
      x.report do
        10000.times { @a.test(1,2,3) }
      end
      x.report do
        10000.times { @a.test(:uno => 1, :dos => 2, :tres => 3) }
      end
    end
  end
  
  it do
    Benchmark.bm do |x|
      x.report do
        class C
          def test(uno = 1, dos = 2, tres = 3, cuatro = 4, cinco = 5, seis = 6, siete = 7, ocho = 8, nueve = 9, diez = 10, once = 11, doce = 12, trece = 13, catorce = 14, quince = 15, dieciseis = 16)
          end
        end
      end
      x.report do
        class D
          def test(uno = 1, dos = 2, tres = 3, cuatro = 4, cinco = 5, seis = 6, siete = 7, ocho = 8, nueve = 9, diez = 10, once = 11, doce = 12, trece = 13, catorce = 14, quince = 15, dieciseis = 16)
          end
          named_args_for :test
        end
      end
    end
  end


end










