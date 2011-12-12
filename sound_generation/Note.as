﻿package{
	public class Note
	{
		public var midiNote:uint;
		public var sample:Sample;
		public var pitchShift: uint;
	
		public function Note(midiNote:uint, sample:Sample, pitchShift: uint)
		{
			this.midiNote = midiNote;
			this.sample = sample;
			this.pitchShift = pitchShift;
		}
	}
}