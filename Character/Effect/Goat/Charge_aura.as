package character.effect.goat {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Charge_aura extends MovieClip {
		
		
		private var _X:Number; 
		private var _Y:Number;
		
		public function Charge_aura(X:Number, Y:Number) {
			x = X+ 2 - 4 * Math.random();
			y = Y + 4 - 8 * Math.random();
			alpha = 0.7;
			_X = Math.random() * 8;
			_Y = -Math.random();
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
