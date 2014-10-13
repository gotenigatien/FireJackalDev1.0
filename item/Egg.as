package item {
	
	import character.CharObj;
	import flash.events.Event;
	
	public class Egg extends GlobalItem {
		protected var lk:Number;
		protected var d:Number;
		protected var dy:Number;
		
		
		public function Egg(ta:CharObj,bs:Array) {
			// constructor code
			target = ta;
			blocstock = bs;
			gravite = 1;
			power_gift = 5;			
			gift_life = 3;
			score = 5;
			di =5;
			hi = -16;
			addEventListener(Event.ENTER_FRAME, run);
		}
		public function run(e:Event) {
			lk = target.x - this.x;d = Math.abs( lk);dy = Math.abs(target.y - this.y);
			moveItemEgg();
			checkTargetCollision();
		}
		
		private function checkTargetCollision():void {
			if (d <= 40 && dy  < 40) {
				if (target.power + power_gift < 75) target.power = target.power + power_gift;
				else target.power = 75;
				if (target.life + power_gift < 100) target.life = target.life + gift_life;
				else target.life = 100;
				target.score = target.score+this.score;
				removeEventListener(Event.ENTER_FRAME, run);
				parent.removeChild(this);
			}
		}	
		
		private function moveItemEgg():void {
				visibility();
				var Lo:int = (y+8) / T;
				y +=  gravite; 							// déplace le perso sur Y
				if (checkFallEgg( Lo)) return ;
				else rotation +=10; 
				if (gravite++ > T) gravite = T;							// limite la gravité max à la taille d'une tuile
		}
		
		
		private function checkFallEgg(L:int):Boolean {
			var i:int;
			// tombe
			var i:int = x / T;
			if (blocstock[L][i].fr) {
				if ((blocstock[L][i].cloud||blocstock[L][i].solide) && y>=(L)* T-8) {			// blocs solides
					y = (L)* T-8								// position du perso sur Y
					return true;
				}
			}
			return false;
		}
	}
}
