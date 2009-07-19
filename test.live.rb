load File.expand_path( File.dirname( __FILE__ ) + '/../scruby.rb' )


# Lamonte Young - Just in tone afination
# Nan Carrow 
44100

s = Server.new('localhost', 57140)
s.boot

s.send "/dumpOSC", 0

clear

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

SynthDef.new :simple do |freq, mul, dur|
  gate = EnvGen.kr( Env.perc(0, 0.2) )
  env  = EnvGen.kr Env.asr(dur * 0.01, dur * 0.2, dur * 0.1), gate, :doneAction => 2
  sig  = SinOsc.ar(freq) * env * mul
  Out.ar 0, [sig, sig]
end.send

Synth.new :simple, :freq => 200, :amp => 1, :dur => 1


freqs = 100, 300, 500, 700, 900, 1100, 1300, 1500, 1700, 1900, 2100, 2300, 2500, 2700, 2900
amps  = 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31
durs  = 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 24, 25, 26, 27, 28

run = true
while run
  freqs.zip amps, durs do |arr|
    freq, amp, dur = arr
    Synth.new :simple, :freq => freq * 1.2 * rand, :mul => 1.0/amp * 0.1 * rand, :dur => dur * 1 * rand
    Synth.new :simple, :freq => freq * 0.9 * rand, :mul => 1.0/amp * 0.2 * rand, :dur => dur * 1 * rand
    Synth.new :simple, :freq => freq * 0.6 * rand, :mul => 1.0/amp * 0.3 * rand, :dur => dur * 1 * rand
  end
  sleep 0.2
end

run = false

p Node.base_id

s.quit


Buffer.read s, "sounds/robot.aiff"


