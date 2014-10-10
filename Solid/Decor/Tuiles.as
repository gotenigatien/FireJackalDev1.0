package Solid.Decor {
	
	import flash.display.MovieClip;
	
	
	public class Tuiles extends MovieClip {
		
		public var fr:int;
		public var cloud:Boolean;
		public var jumper:Boolean;
		public var item:Boolean = false;
		public var slope:int = 0;
		public var gradient:int;
		public var upPulse:Number = 0;
		public var solide:Boolean=false;
		public var destruct:Boolean=false;
		public var resist:int = 0;
		public var life:int = 0;
		public var power:int = 0;
		public var score:int = 0;
		
		public function Tuiles() {
			// constructor code
		}
		public function destroy() {
			fr = 0;
			solide = false;
			item = false;
			destruct = false;
			gotoAndStop(10);
		}
	}
	
}
