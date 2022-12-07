// Sound Design
(// Gong
SynthDef(\gong, {
	| sig env release variation |
	release = \rel.kr(6);
	variation = {Rand(0.8, 1.2)}!6;
	env = Env.perc(\atk.kr(0.01), release*variation, 0.2*variation).kr(0);
	sig = SinOsc.ar(\freq.kr(440)*[1, 2.26, 3.73, 8.21], 0, env);
	sig = Splay.ar(sig, 0.2) * \amp.kr(1);
	Out.ar(\out.kr(0), sig);
	Line.kr(0, 1, release*1.21, 1, 0, 2)
}).add;
)
Synth(\gong, [\freq, exprand(50, 300)])


// || C | Ab Bb ||
// || Eb | F | C | % ||

// Centro em C, claramente
// Modal. Misturando C maior com menor?
// Jogo de terças do romantismo? (Eb - C - Ab)
// Cm Dø Eb Fm Gm Ab Bb
// Cm Dø Eb+ Fm G Ab Bº
// Cm Dm Eb+ F G Aø Bø
// C Dm Em F G Am Bø