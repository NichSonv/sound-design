// Lab de interferência construtiva, destrutiva e frequência de batimentos ===========

(
x = {
	SinOsc.ar(440)+SinOsc.ar(\freq2.kr(440, 0.2), \phase2.kr(0, 0.2))!2 * 0.5;
}.play
)
x.set(\phase2, 0)
x.set(\freq2, 440)
s.scope

// Isso é AM ou FM?
// Interessante que, ao mudar a frequência e retornar à original, naturalmente ocorre uma defasagem entre as duas senóides (o retorno precisa ocorrer exatamente no momento em que os dois picos das ondas estiverem alinhados, senão elas se emparelham em fases diferentes)

// Synthesizing waves by addictive synthesis ===========

// cs.wellesley.edu/~cs203/lecture_materials/waves/waves.pdf - URL

// PS: Klang - bank of SinOsc's, useful for additive synthesis?

// 1. Sawtooth wave...

// for comparison
{Saw.ar(100)}.play
{LFSaw.ar(100)}.play

// p stands for the partial number.
// ~saw = SinOsc.ar(100*p, 0, 1/p); or
// ~saw = SinOsc.ar(100*p, [p.odd->0, p.even->pi], 1/p); for a saw that ramps up instead of down
// PS... using phase pi for every partial seems to do the same as giving it [pi, 0] over and over...
(
fork{
	~saw.free;
	s.sync;
	~saw = {
		| sig partials harm phase |
		harm = 200; // number of partials in the synthesis
		partials = (1..harm);
		phase = Array.fill(harm, Pseq([0, pi], inf).iter);
		sig = SinOsc.ar(100*partials, phase, 1/partials) * 0.5;
		sig = Mix(sig)!2;
	}.play;
}
)
(
fork{
	~saw.free;
	s.sync;
	~saw = {
		| sig partials harm phase |
		harm = 200;
		partials = (1..harm);
		phase = Array.fill(harm, Pseq([0, pi], inf).iter);
		sig = DynKlang.ar(`[100*partials, 1/partials, phase]) * 0.5;
		sig = sig!2;
	}.play;
}
)

// 2. Triangle wave...

// for comparison
{LFTri.ar(100)}.play

// ~tri = SinOsc.ar(100*p.odd, [0, 1.5pi].choose, 1/p**2);
// every other harmonic is 180º out of phase
(
fork{
	~tri.free;
	s.sync;
	~tri = {
		| sig partials harm phase |
		harm = 30;
		partials = (1, 3..harm*2-1); // only odd partials
		phase = Array.fill(if(harm>1){harm/2}{1}, Pseq([pi, 0], inf).iter);
		sig = SinOsc.ar(100*partials, phase, 1/(partials**2)) * 0.5;
		sig = Mix(sig)!2;
	}.play;
}
)
( // Using DynKlang
fork{
	~tri.free;
	s.sync;
	~tri = {
		| sig partials harm phase |
		harm = 100;
		partials = (1, 3..harm*2-1); // only odd partials
		phase = Array.fill(if(harm>1){harm/2}{1}, Pseq([pi, 0], inf).iter);
		sig = DynKlang.ar(`[100*partials, 1/(partials**2), phase]) * 0.5;
		sig = sig!2;
	}.play;
}
)

// 3. Square wave...

// for comparison
{Pulse.ar(100)}.play
{LFPulse.ar(100, add: -0.5)}.play

// ~sqr = SinOsc.ar(100*p.odd, 0, 1/p);
(
fork{
	~sqr.free;
	s.sync;
	~sqr = {
		| sig partials harm |
		harm = 19;
		partials = (1, 3..harm*2-1); // only odd partials
		sig = SinOsc.ar(100*partials, 0, 1/partials) * 0.5;
		sig = Mix(sig)!2;
	}.play;
}
)
( // Using DynKlang
fork{
	~sqr.free;
	s.sync;
	~sqr = {
		| sig partials harm |
		harm = 20;
		partials = (1, 3..harm*2-1); // only odd partials
		sig = DynKlang.ar(`[100*partials, 1/partials]) * 0.5;
		sig = sig!2;
	}.play;
}
)