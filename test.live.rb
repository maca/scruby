load File.expand_path( File.dirname( __FILE__ ) + '/../scruby.rb' )

s = Server.new
s.boot

10.times { |i| print "hola #{i}" }

1+1

# Síntesis aditiva básica
SynthDef.new :add do
  gate  = EnvGen.kr( Env.perc(0, 0.2) )
  freqs = 1100, 1320, 1540, 1980
  amps  = 0.5, 0.5, 0.5, 0.5
  env   = EnvGen.kr Env.adsr(0.9, 0.1, 1, 0.5), gate, :doneAction => 2
  sig   = freqs.zip(amps).inject SinOsc.ar(220) do |sum, args|
    sum + SinOsc.ar( args.first, :mul => args.last )
  end
  Out.ar 0, [sig * env, sig * env]
end.send

test = Synth.new :add, :gate => 1



# Síntesis aditiva básica 2
SynthDef.new :dos do |dur, freq|
  gate     = EnvGen.kr( Env.perc(0, 0.2) )
  freq_env = EnvGen.kr Env.new( [100, 500*freq, 400*freq, 600*freq, 300*freq], [dur*3/4, dur*3/4, dur*3/4, dur*3/4] ), gate
  amp_env  = EnvGen.kr Env.new( [0, 1, 0.8, 1, 0], [dur*3/4, dur*3/4, dur*3/4, dur*3/4] ), gate, :doneAction => 2
  Out.ar( 0, SinOsc.ar( freq_env) * amp_env )
end.send

test = Synth.new :dos, :dur => 5, :freq => 1
test = Synth.new :dos, :dur => 5, :freq => 1.7
test = Synth.new :dos, :dur => 5, :freq => 1.6
test = Synth.new :dos, :dur => 5, :freq => 1.3

s.stop


# Construcción de una onda cuadrada
SynthDef.new :simple do |freq, mul, dur|
  gate = EnvGen.kr( Env.perc(0, 0.2) )
  env  = EnvGen.kr Env.asr(dur * 0.1, dur * 0.2, dur * 0.8), gate, :doneAction => 2
  sig  = SinOsc.ar(freq) * env * mul
  Out.ar 0, [sig, sig]
end.send

mults  = 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29
durs   = 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 24, 25, 26, 27, 28
base   = 40
dur    = 1
amp    = 0.2

mults.zip durs do |mult, dur|
  Synth.new :simple, :freq => mult * base, :mul => amp/mult, :dur => dur
end


# Amplitud modulada
# Alteración de la amplitud, fase o frecuencia por otra señal
SynthDef.new :am do |mod_freq, mod_amp, amp, freq, dur|
  gate = EnvGen.kr( Env.perc(0, 0.2) )
  mod  = SinOsc.kr mod_freq, :mul => mod_amp
  sig  = SinOsc.ar freq, :mul => mod + amp
  sig  = sig * EnvGen.kr( Env.asr(dur * 0.1, dur * 0.2, dur * 0.8), gate, :doneAction => 2 )
  Out.ar 0, [sig, sig]
end.send

si = Synth.new :am, :mod_freq => 100, :mod_amp => 1, :amp => 0.5, :dur => 2, :freq => 60


# Modulación en anillo
SynthDef.new :ring do |mod_freq, freq, amp, dur|
  gate  = EnvGen.kr Env.perc(0, 0.2)
  sig   = SinOsc.ar freq, :mul => SinOsc.ar(mod_freq, :mul => amp)
  sig  *= EnvGen.kr( Env.asr(dur * 0.1, dur * 0.2, dur * 0.8), gate, :doneAction => 2 )
  Out.ar 0, [sig, sig]
end.send


si = Synth.new :ring, :freq => 2000, :amp => 2, :dur => 2, :mod_freq => 4


si.to_s

# Sound0.aiff
# Modulación en anillo con sampleo
# Modulación en anillo
buffer  = Buffer.read s, "sounds/huge.aiff"

buffer2 = Buffer.read s, 'sounds/a11wlk01-44_1.aiff'
buffer2.buffnum

buffer.read 'sounds/a11wlk01-44_1.aiff'

SynthDef.new :ring do |mod_freq, amp, buffnum|
  gate  = EnvGen.kr Env.perc(0, 0.2)
  sig   = PlayBuf.ar buffnum, :rate => 1, :mul => SinOsc.ar(mod_freq, :mul => amp), :loop => 1.0
  Out.ar 0, [sig, sig]
end.send

s1 = Synth.new :ring, :freq => 90, :amp => 2, :dur => 2, :mod_freq => 4, :buffnum => buffer.buffnum
s2 = Synth.new :ring, :freq => 90, :amp => 2, :dur => 2, :mod_freq => 4, :buffnum => buffer.buffnum

s1.set :mod_freq => 80
s2.set :mod_freq => 9000

s1.set :buffnum => buffer2.buffnum

s1.free

s2.free
# node ids should depend on server

s1

s.stop



# Síntesis por FM
SynthDef.new :campana do |freq, amp, dur|
  gate     = EnvGen.kr Env.perc(0, 0.2)
  mod_env  = EnvGen.kr Env.new([600, 200, 100], [0.7,0.3].map{|v|v*dur}), gate
  mod      = SinOsc.ar freq * 1.4, :mul => mod_env
  sig      = SinOsc.ar freq + mod
  env      = EnvGen.kr Env.new( [0, 1, 0.6, 0.2, 0.1, 0 ], [0.001, 0.005, 0.3, 0.5, 0.7].map{|v|v*dur} ), gate, :doneAction => 2
  sig      = sig * amp * env
  Out.ar [sig, sig]
end.send

camp = Synth.new :campana, :freq => 200, :amp => 0.8, :dur => 5




# Chido
SynthDef.new :wood_drum do |freq, amp, dur|
  gate     = EnvGen.kr Env.perc(0, 0.2)
  mod_env  = EnvGen.kr Env.new([1600, 200, 50, 90, 10], d(0.7,0.3,0.4,0.4)*dur ), gate
  mod      = SinOsc.ar freq * 0.6875, :mul => mod_env
  sig      = SinOsc.ar freq + mod
  env      = EnvGen.kr Env.new( [0, 1, 0.6, 0.2, 0.1, 0 ], [0.1, 0.5, 0.5, 0.7, 0.9].map{|v|v*dur} ), gate, :doneAction => 2
  sig      = sig * amp * env
  Out.ar [sig, sig]
end.send

camp = Synth.new :wood_drum, :freq => 184,  :amp => 0.8, :dur => 10
camp = Synth.new :wood_drum, :freq => 180,  :amp => 0.8, :dur => 10

s.stop



# Síntesis por FM
SynthDef.new :wood_drum do |freq, amp, dur|
  gate     = EnvGen.kr Env.perc(0, 0.2)
  mod_env  = EnvGen.kr Env.new([1600, 200, 50, 90, 10]*2, d(0.7,0.3,0.4,0.4)*dur ), gate
  mod      = SinOsc.ar freq * 0.6875, :mul => mod_env
  sig      = SinOsc.ar freq + mod
  env      = EnvGen.kr Env.new( [0, 1, 0.6, 0.2, 0.1, 0 ], [0.1, 0.5, 0.5, 0.7, 0.9].map{|v|v*dur} ), gate, :doneAction => 2
  sig      = sig * amp * env
  Out.ar [sig, sig]
end.send

camp = Synth.new :wood_drum, :freq => 184,  :amp => 0.8, :dur => 100
camp = Synth.new :wood_drum, :freq => 180,  :amp => 0.8, :dur => 10
camp = Synth.new :wood_drum, :freq => 180,  :amp => 0.8, :dur => 1


s.stop


camp.free

[0.001, 0.005, 0.3, 0.5, 0.6].inject{ |sum, val| sum + val * 10 }



# Convolución
# Artículo Rhodes tutorial
# Multiplicación de dos señales, el resultado es todo lo que coincide en las dos señales


buffer = Buffer.read s, "sounds/Sound0.aiff", :frames => 10460




SynthDef.new :convo do |dur, buffnum|
  sig  = WhiteNoise.ar
  sig *= EnvGen.kr Env.perc(0, 0.5), :doneAction => 2
  buff = PlayBuf.ar buffnum, :rate => 0.6, :loop => 1.0
  sig  = Convolution.ar buff, sig, 1024, 0.5 
  Out.ar 0, [sig]*2
end.send


Synth.new :convo, :dur => 1, :buffnum => buffer.buffnum








# Radios que funcionan para



# Lamonte Young - Just in tone afination
# Nan Carrow 
# Stockhausen
