﻿package  character.effect.jackal{
	
	import flash.display.MovieClip;
	
	public class Burning extends MovieClip {
		
		
		public function Burning() {
			// constructor code
			alpha = 0.45;
			//this.addEventListener(Event.ENTER_FRAME, update);
		}
		public function stickB(_x:Number,_y:Number) {
			this.x = _x;
			this.y = _y+20;
			
		}
		public function startB() {
			gotoAndPlay(2);
			
		}
		public function stopB() {
			gotoAndStop(1);
		}
	}
	
}
