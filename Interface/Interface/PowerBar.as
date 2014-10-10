package Interface.Interface {
	
	import Character.CharObj;
	import flash.display.MovieClip;
	import flash.events.Event;
		
	public class PowerBar extends MovieClip {
		
		
	
		private var maxP:int;
		private var percentP:Number;
		private var cPower:int;
		private var pl:CharObj;
		
		public function PowerBar($pl:CharObj) {
			// constructor code
			 maxP = 75; cPower = 25;
			 percentP = cPower / maxP;
			 clBar.scaleX = percentP;
			 pl = $pl;
			 addEventListener(Event.ENTER_FRAME, run);
		}
		public function run(e:Event) {
			if (pl.die) this.emptyBar();
			else this.updateBar(pl.power);
		}
		public function emptyBar():void {
			updateBar(-1);
		}
		public function updateBar(power:int):void
		{	if(power!=cPower){
			percentP = power / maxP;
			 if (cPower > power)  { clBar.scaleX =  clBar.scaleX - 0.01; flcursor.x = flcursor.x - 1.48; }
			 if (cPower < power) {clBar.scaleX =  clBar.scaleX + 0.01;flcursor.x = flcursor.x + 1.48;}
			 if (Math.abs(clBar.scaleX-percentP) <0.01) cPower = power;
			if (percentP ==1) this.clBar.gotoAndStop(4);
			 else if (percentP < 1 && percentP >= 0.66) this.clBar.gotoAndStop(3);
			 else if (percentP < 66 && percentP >= 0.33) this.clBar.gotoAndStop(2);
			 else if (percentP < 0.33) this.clBar.gotoAndStop(1);
			 flcursor.alpha = int(cPower!=0&&cPower!=-1);
			}
		}
	}
	
}
