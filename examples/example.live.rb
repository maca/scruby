scruby = "#{File.expand_path( File.join( File.dirname( __FILE__), '..', 'scruby' )  )}"
require scruby
s = Server.new('localhost', 57140)
s.boot

require File.expand_path( File.join( File.dirname(__FILE__),'..','..', '..', 'Sequentiable', 'lib', 'metro' ) )
require File.expand_path( File.join( File.dirname(__FILE__),'..','..', '..', 'HumanGenome', 'lib', 'human_genome' ) )



sdef  = SynthDef.new :test, :values => [456, 0.34, 0.45] do |freq, ancho, amp|
  gate = EnvGen.kr( Env.perc(0, 0.2) )
  sig  = SinOsc.ar( [freq, freq * 1.01], :mul => SinOsc.kr(40) * amp * 0.7 ) * EnvGen.kr( Env.asr(2, 1, 3), gate, :doneAction => 2 )
  sig  = SinOsc.ar( [freq, freq * 1.01], :mul => SinOsc.kr(8) * amp * 0.3 ) * EnvGen.kr( Env.asr(2, 1, 2), gate ) + sig
  sig  = SinOsc.ar( [freq * 0.25, freq * 0.251], :mul => SinOsc.kr(30) * amp * 0.3 ) * EnvGen.kr( Env.asr(2, 1, 2.5), gate ) + sig
  sig  = SinOsc.ar( freq * 2, :mul => SinOsc.kr(500, :mul => 0.1) * amp * 0.2 ) * EnvGen.kr( Env.asr(0, 1, 2), gate ) + sig
  sig  = SinOsc.ar( freq * 0.25, :mul => amp * 0.2 ) * EnvGen.kr( Env.asr(0, 1, 0.4), gate ) + sig
  Out.ar( 0, sig)
end
sdef.send
sleep 0.05
test = Synth.new :test, :freq => 2000, :amp => 1
sleep 0.2




bass.set( :gate => 0)


s.stop

test.free
bass.free



