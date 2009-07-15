load File.expand_path( File.dirname( __FILE__ ) + '/../scruby.rb' )


# Lamonte Young - Just in tone afination
# Nan Carrow 
44100

s = Server.new('localhost', 57140)
s.boot

s.send "/dumpOSC", 1

clear

# Síntesis aditiva
SynthDef.new :add do |gate|
  freqs = 1100, 1320, 1540, 1980
  amps  = 0.5, 0.5, 0.5, 0.5
  env   = EnvGen.kr Env.adsr(0.9, 0.1, 1, 0.5), gate, :doneAction => 2
  sig   = freqs.zip(amps).inject SinOsc.ar(220) do |sum, args|
    sum + SinOsc.ar( args.first, :mul => args.last )
  end
  Out.ar 0, [sig * env, sig * env]
end.send

test = Synth.new :add, :gate => 1

s.quit


Buffer.read s, "sounds/robot.aiff"

1


class Smock
  def encode
    [ 83, 67, 103, 102, 0, 0, 0, 1, 0, 1, 4, 104, 111, 108, 97, 0, 2, 67, -36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 83, 105, 110, 79, 115, 99, 2, 0, 2, 0, 1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 1, 2, 0, 0 ].pack('C*')
  end
end

s.send_synth_def Smock.new

