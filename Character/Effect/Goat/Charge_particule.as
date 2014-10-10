package character.effect.goat {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Charge_particule extends MovieClip {
		
		
		private var _X:Number; 
		private var _Y:Number;
		
		public function Charge_particule (X:Number, Y:Number) {
			x = X+ 3 - 6 * Math.random();
			y = Y + 4 - 16 * Math.random();
			
			this.gotoAndStop(5-int(4*Math.random()));
			_X = Math.random() * 8;
			_Y = -Math.random()*1.3;
			addEventListener(Event.ENTER_FRAME, update);
		}
 
		private function update(e:Event):void{
			x += _X;
			y += _Y;
		}
 
		public function kill():void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
	}
	
}
