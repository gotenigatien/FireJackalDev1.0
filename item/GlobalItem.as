package item {
	
	import flash.display.MovieClip;
	import character.CharObj;
	import engine.Carte;
	
	public class GlobalItem extends MovieClip {
		protected var target:CharObj;
		protected var T:int;
		protected var blocstock:Array;
		protected var gift_life:int;
		protected var power_gift:int;	
		protected var score:int;		
		protected var gravite:Number;	
		private var d:Number;
		private var dy:Number;	
		public var di:int;	
		public var hi:int;	
		protected var sloping:Boolean=false;
		protected var pulse:Boolean = false;
		protected var jumpPuls:Number;
		
		public function GlobalItem() {
			// constructor code
			T = Carte.T;
		}
		
		
		protected function visibility():void {
				var V_dg:Boolean = x + di > -parent.parent.x && x - di < 800 - parent.parent.x;
				var V_hb:Boolean = y + T > -parent.parent.y && y - hi < 480 - parent.parent.y;
				if ( V_dg && V_hb) visible = true;  else visible = false;
				
		}
		
		
		
		
	}
	
}
