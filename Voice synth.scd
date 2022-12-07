(
SynthDef(\voice, {
	| hz air raspy sig env |
	hz = \freq.kr(200, 0.2);
	env = Env.asr(\atk.kr(0.2), 1, \rel.kr(0.1)).kr(2, \gate.kr(1));
	air = WhiteNoise.ar;
	air = LPF.ar(air, 300);
	raspy = Saw.ar(hz/2, env) / 2;
	raspy = LPF.ar(raspy, 1e3, 1);
	sig = SinOsc.ar(hz);
	sig = Mix([air, raspy, sig]*[1.3, 0.6, 0.8]*0.2) * env * \amp.kr(1);
	sig = Pan2.ar(sig, \pan.kr(0, 0.2));
	Out.ar(\out.kr(0), sig)
}).add
)
x = Synth(\voice)
x.set(\pan, -0.6)
x.set(\gate, 0)

(
~measure = 60/50;
~notes = Pseq([43, 47, 48, 51, 50]);
~durs = Pseq([1, 1, 1, 1, 2]);
)

(
p = PmonoArtic(\voice,
	\dur, ~durs,
	\stretch, ~measure,
	\midinote, ~notes,
	\legato, 1,
	\amp, 1
).play
)