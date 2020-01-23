scruby = File.expand_path(File.join(File.dirname(__FILE__), "..", "scruby")).to_s
require scruby
s = Server.new("localhost", 57_140)
s.boot
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "Sequentiable", "lib", "metro"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "HumanGenome", "lib", "human_genome"))

sdef = SynthDef.new :melo, values: [ 456, 0.34, 0.45 ] do |freq, amp, a, _b, c|
  gate = EnvGen.kr(Env.perc(0, 0.2))
  sig  = SinOsc.ar([ freq, freq * 1.01 ], mul: SinOsc.kr(40) * amp * 0.7, add: SinOsc.kr(0.5, mul: 2.5)) * EnvGen.kr(Env.asr(2, 1, 3), gate, doneAction: 2)
  sig  = SinOsc.ar([ freq, freq * 1.01 ], mul: SinOsc.kr(8) * amp * 0.3, add: SinOsc.kr(0.5, mul: 2.5)) * EnvGen.kr(Env.asr(2, 1, 2), gate) + sig
  sig  = SinOsc.ar([ freq * 0.25, freq * 0.251 ], mul: SinOsc.kr(30) * amp * 0.3) * EnvGen.kr(Env.asr(2, 1, 3), gate) + sig
  sig  = SinOsc.ar(freq * 2, mul: SinOsc.kr(500, mul: 0.1) * amp * 0.1) * EnvGen.kr(Env.asr(0, 1, 2), gate) + sig
  sig  = SinOsc.ar(freq * 0.25, mul: amp * 0.2) * EnvGen.kr(Env.asr(0, 1, 0.4), gate) + sig
  res  = Resonz.ar(sig, EnvGen.kr(Env.asr(0.5, 3, c * 2)) * a * 10_000)
  Out.ar(0, [ res[0] * 6 + sig[1] * 0.8 ] * 2)
end
sdef.send
sleep 0.05
test = Synth.new :melo, freq: 220, amp: 0.5

# [1] * 2 = [1,1]

s.stop


sdef = SynthDef.new :perc, values: [ 456, 0.34, 0.45 ] do |freq, amp, a, b|
  dur = a
  amp *= 0.25
  freq *= 0.05
  sig = SinOsc.ar(Line.kr(freq * 1.5, freq * 1.1, dur), Math::PI / 2, amp * 0.2 * SinOsc.kr(10))
  # sig = Resonz.ar( sig, EnvGen.kr( Env.asr(0.5, 3, 2) ) * 120, 0.5 )
  # sig = LPF.ar( sig, 120 )
  sig = HPF.ar(WhiteNoise.ar(amp * 0.1), freq * 10) * b * 0.8 + sig
  # sig = Pan2.ar( sig, 0)
  env = EnvGen.kr Env.perc(0, dur), doneAction: 2
  Out.ar 0, [ sig * env ] * 2
end
sdef.send
sleep 0.05
test = Synth.new :perc, freq: 1000, amp: 0.5, dur: rand

sdef = SynthDef.new :perc, values: [ 456, 0.34, 0.45 ] do |freq, amp, a, _b|
  dur = a
  amp = amp
  freq *= 0.1
  sig = SinOsc.ar(Line.kr(freq * 1.5, freq * 1.1, dur), Math::PI / 2, amp * 0.2 * SinOsc.kr(10))
  sig = HPF.ar(WhiteNoise.ar(amp * 0.1), freq * 10) * 0.8 + sig
  env = EnvGen.kr Env.perc(0, dur), doneAction: 2
  Out.ar 0, [ sig * env ] * 2
end
sdef.send
sleep 0.05
test = Synth.new :perc, freq: 1000, amp: 0.5, dur: rand

sdef = SynthDef.new :perc, values: [ 456, 0.34, 0.45 ] do |freq, _amp, _a, _b|
  gate = EnvGen.kr Env.perc(0, 0.1)
  env = EnvGen.kr Env.asr(0.1, 4, 1), gate, doneAction: 2
  sig = DelayC.ar(SinOsc.ar(freq), 4, SinOsc.ar(SinOsc.ar(SinOsc.ar(2))))
  Out.ar(0, [ sig * env ] * 2)
end
sdef.send
sleep 0.05
test = Synth.new :perc, freq: 1000, amp: 0.5, dur: rand
# sleep 0.8

s.stop

sleep 0.05
test = Synth.new :test, freq: 20, amp: 1
