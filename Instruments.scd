// SYNTHS ==========

// PHYSICAL SIMULATION ==========

// Fire simulation (Farnell)
( // Crackling
SynthDef(\crack, {
	| sig env |
	env = EnvGen.kr(Env.perc(0.001, Rand(0.05, 0.2)), doneAction: 2);
	sig = WhiteNoise.ar;
	sig = HPF.ar(sig, ExpRand(1e3, 2e3), env);
	Out.ar(\out.kr(0), sig)
}).add;
)
Synth(\crack)

( // Bass Drum
SynthDef(\kickDrum, {
	| sig env fenv penv rough kick mallet |
	env = Env.perc.kr(2);
	fenv = XLine.ar(180, 30, 0.2);
	penv = Env.perc(0.01, 0.1).kr;
	rough = LPF.ar(Saw.ar(60), fenv);
	kick = SinOsc.ar(fenv, 0, 0.8);
	mallet = BPF.ar(PinkNoise.ar(penv), 180, 0.7, 1/0.7);
	sig = rough + kick + mallet;
	sig = (sig * env)!2;
	Out.ar(0, sig)
}).add;
)
Synth(\kickDrum)

(
SynthDef(\string, {
	| sig env done release partials amplitudes decays |
	release = \decay.kr(7);
	partials = \freq.kr(100, 0.3)*[1, 2.02, 2.99, 4, 5.01];
	amplitudes = [1]++({ExpRand(0.2, 1)}!4);
	decays = [release]++({ExpRand(0.5, release)}!4);
	env = Env.perc(0.01, 0.02).kr;
	sig = WhiteNoise.ar(0.1!2) * env;
	sig = DynKlank.ar(`[partials, amplitudes, decays], sig);
	sig = Splay.ar(sig, 0.2, 0.1);

	done = Env.perc(0, release).kr(2);
	Out.ar(\out.kr(0), sig)
}).add;
)
Synth(\string)

// SINTETIZANDO SERIES ==========

(
SynthDef(\dynKlank, {
	| sig env done release |
	release = \decay.kr(1);
	env = Env.perc(0.01, 0.05, 0.01).kr;
	sig = WhiteNoise.ar(env!2);
	sig = DynKlank.ar(`[
		[\freq.kr(300, 0.2)]*([1, 2, 2, 4, 5, 6]+({Rand(-0.2, 0.2)}!6)), // freq
		(\amp.kr(1)*({Rand(0.2, 1)}!6)), // amp
		[release]++(release*{Rand(0.2, 0.99)}!5) // dur
	], sig);
	sig = Splay.ar(sig, 0.2);

	done = Env.perc(0, release).kr(doneAction:2);
	Out.ar(0, sig)
}).add;
)
Synth(\dynKlank)