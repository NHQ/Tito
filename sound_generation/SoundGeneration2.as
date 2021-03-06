﻿package 
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.Capabilities;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface; 
	import flash.events.Event; 
	import com.adobe.flash.samples.SoundPitchShift;
	
	
	
	public class SoundGeneration2 extends MovieClip
	{
		//Global Constants
		private var PITCHBEND_RATIOS = 
		{
			"0": 1,
			"1": 1.059327217125382,
			"2": 1.122324159021407,
			"3": 1.18960244648318,
			"4": 1.259938837920489,
			"5": 1.335168195718654,
			"6": 1.414067278287462,
			"7": 1.498470948012232,
			"8": 1.587767584097859,
			"9": 1.681957186544342,
			"10": 1.782262996941896,
			"11": 1.888073394495413,
			"12": 2
		};
		
		private var NUM_VOICES = 5;
		
		//Member Variables
		private var debugMode:Boolean; 
		private var isMuted:Boolean;
		private var isLoaded:Boolean;
		private var snd:Sound;
		private var samplePath:String;
		private var theMultiSample:MultiSample;
		private var voices:Array;
		private var lastUsedVoice = 0;
		
		//Constructor
		public function SoundGeneration2()
		{
			//Initialize some of our member variables
			this.debugMode = (Boolean) (Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External");
			this.isMuted = false;
			this.isLoaded = false;
			this.snd = new Sound();
			
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("playNote", playNote);
				ExternalInterface.addCallback("setMute", setMute);
			}
			
			if(debugMode) {
				this.samplePath = "../../_/snd/";
				trace("DEBUG MODE");
				trace(Capabilities.playerType);
			} else {
				this.samplePath = "_/snd/";
			}
	
			//theMultiSample = new ToyPianoMultiSample();
			theMultiSample = new AutoharpMultiSample();
			theMultiSample.loadAllSamples(this.samplePath);
			theMultiSample.addEventListener(Event.COMPLETE, allSamplesLoaded);
			
			voices = new Array(NUM_VOICES);
			for(var i=0;i<NUM_VOICES;i++)
			{
				voices[i] = new SoundPitchShift();
			}
		}
		
		private function incrementAndGetVoice():SoundPitchShift
		{
			this.lastUsedVoice++;
			if(lastUsedVoice == NUM_VOICES) lastUsedVoice = 0;
			return voices[lastUsedVoice];
		}
		
		//Plays the note. Take a MIDI note number as a param
		public function playNote(noteNumber:int)
		{
			if(this.isMuted) return;
			if(!this.isLoaded) return;
			
			var currentVoice:SoundPitchShift = incrementAndGetVoice();
			currentVoice.stop();
				
			if(this.theMultiSample.isNoteDefined(noteNumber))
			{
				var pitchBendAmount = this.theMultiSample.theNotes[noteNumber].pitchShift;
				var sample:Sample = this.theMultiSample.theNotes[noteNumber].sample;
				
				trace(pitchBendAmount);
				if(typeof(pitchBendAmount) != 'undefined')
				{
					var noteRatio = PITCHBEND_RATIOS[pitchBendAmount];
					if(noteRatio)
					{
						trace(noteRatio);
						if(sample != null)
							
						currentVoice.play(sample.sound, noteRatio);
					}
				}
			}
		} /* function playNote()*/
		
		//Sets whether or not MUTE is turned on
		function setMute(muteValue:Boolean)
		{
			isMuted = muteValue;
		} /*setMute() */
	
		//This is called when the sample is loaded (single-sample mode)
		function allSamplesLoaded(event:Event):void
		{
			isLoaded = true;
			
			if(debugMode)
			{
				trace("PLAYING NOTE");
				playNote(48);
			}
		} /* allSamplesLoaded()*/
		
	} /* class SoundGeneration2 */
} /* package */