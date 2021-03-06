
// testing fn-sequences

Server.killAll;

s.boot;


(
~bpm = 140;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


(
~delay.set(\amp, 0.2);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.9);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);
)


(

("./midiknobs.scd").loadRelative();

)


("./sequencer.scd").loadRelative();


// todo - a way to map control knobs to parameters which
// arent just 0-1

(
~grains.map(\mix, ~knobs[0]);
~grains.map(\blur, ~knobs[1]);
~grains.map(\pitch, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)

~grains.set(\amp, 0.35);

("./midikeys.scd").loadRelative();


~scale = Scale.chromatic();

~release = { |i| i > 11 }


(

~rquant = {
	arg f, denom;
	if( denom != 0, {
		var fraction = f.asFraction(denom);
		fraction[0] / fraction[1];
	},
	{ f }
	);
};
)

(
~insts = [
	[ \kickt,  4,  {
		|i, note|
		Synth.head(nil, \kick, [
			\rel, 0.2,
			\noise, 0.9,
			\hi, i * 40 + 80, \lo, i * 20 + 60,
			\pan, 0,
			\out, ~fxb ]); nil } ],
	[ \snaret, 8,  { |i, note| Synth.head(nil, \snare, [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, (i - 10) * 0.2, \out, ~fxb   ]); nil;  }  ],
	[ \tinet,  12,  {
		|i, note|
		Synth.head(nil, \tine, [
			\out, ~grainsb,
			\freq, ~scale.degreeToFreq(i, 110, 0),
			\a, 2.8,
			\partials, 0.6,
			\fade, 0.7,
			\pan, (i - 6) * 0.4,
			\amp, note[\velocity] / 200
	]);
		nil;
	} ],
[ \sawt, 41, {
	| i, note |
	var freq = ~scale.degreeToFreq(i, 110, 0);
	Synth.head(nil, \detunesaw, [
		\out, ~grainsb,
		\freq, freq,
		\atk, 0.01,
		\rel, 0.4,
		\pan, (i - 26.5) * 0.3,
		\amp, note[\velocity] / 127
	]);
} ]
]

)


s.sendMsg('/n_free', 1070);

~recording = '';

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='mel';
~metronome.value('metronome', 1, 4);
~remove.value('mel');

~notes.removeAllSuchThat({|n| n[\synth][0] == \snare });

~notes.do({|n| n[\time].postln})
~notes.size
~notes;


~savepattern.value('looptober22', ~notes);

