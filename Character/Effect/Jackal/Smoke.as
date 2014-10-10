package character.effect.jackal {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Smoke extends MovieClip {
		
		private var _X:Number = 0; 
		private var _Y:Number = 0;
		
		public function Smoke (X:Number, Y:Number) {
			x = X;
			y = Y;
			scaleX = scaleY = Math.random()*0.3-0.1;
			alpha = 0.4;
			_X = Math.random() * 0.6 - 0.3;
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void{
			x += _X;
			y += _Y;
			scaleX = scaleY *= 1.03;
			alpha -= 0.00005;
			_Y += -0.05;
		}
		
		public function kill():void{
			removeEventListener(Event.ENTER_FRAME, update);
		}
	}
	
}
