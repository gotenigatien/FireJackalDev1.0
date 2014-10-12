package solid.decor {
	
	public class Bloc {
		
		
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
		
		public function Bloc() {
			
		}	
		public function destroy():void {
			fr = 0;
			solide = false;
			item = false;
			destruct = false;
		//	gotoAndStop(10);
		}
		
		
	}
	
	
}