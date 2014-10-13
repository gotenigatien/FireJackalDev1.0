package uig.uig {
	
	import character.CharObj;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class LifeBar extends MovieClip {
		
		private var maxHP:int;
		private var percentHP:Number;
		private var cHP:int;
		private var pl:CharObj;
		public function LifeBar($pl:CharObj) {
			// constructor code
			 maxHP = 100; cHP = 100; percentHP = 1;pl = $pl;
			 addEventListener(Event.ENTER_FRAME, run);
		}
		public function run(e:Event) {
			if (pl.die) this.emptyBar();
			else this.updateBar(pl.life);
		}
		public function emptyBar():void {
			updateBar(-1);
		}
		public function updateBar(life:int):void
		{
			if(life!=cHP&&life<=100){
				 percentHP = life / maxHP;
				 if (cHP > life) { clBar.scaleX =  clBar.scaleX - 0.01;cllife.x = cllife.x -1.8; }
				 if (cHP < life) {clBar.scaleX =  clBar.scaleX + 0.01;cllife.x = cllife.x +1.8; }
				 if (Math.abs(clBar.scaleX-percentHP) <0.01)	 cHP = life;
				 
				 if (percentHP > 0.5) {this.clBar.gotoAndStop(1);cllife.gotoAndStop(1)}
				 else if (percentHP <= 0.5 && percentHP > 0.25) {this.clBar.gotoAndStop(2);cllife.gotoAndStop(2)}
				 else if (percentHP <= 0.25) {this.clBar.gotoAndStop(3);cllife.gotoAndStop(3)}
				 cllife.alpha = int(cHP!=0&&cHP!=-1);
			}
		}
	}
	
}
