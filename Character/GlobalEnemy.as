package character {
	import engine.Carte;
	import flash.utils.Timer;
	public class GlobalEnemy extends CharObj{
			
		public var target:CharObj = new CharObj();
		public var IAtype:int;
		public var Etype:int;
		public var InPos:Array;
		protected var left:Boolean;
		protected var right:Boolean;
		protected var aucune:Boolean;
		protected var lk:Number;
		private var finishTime:Timer = new Timer(200,5);
		public function GlobalEnemy() {
		}
		
		protected function CheckProj():void {
			var i:Object;var d:Number;var dy:Number;var a;
			for each(i in tabFire){
				d =  Math.abs( i.x - this.x - this.di);
				dy = Math.abs(i.y - this.y);
				var b:Number = i.width / 3;
				var c:Number = i.height;
				if(d <= b && dy  < c){
					if (!imunTime.running) {
						imunTime.start();
						a = i.force-this.life;
						this.life = this.life - i.force;
						i.force = a;
						if (this.life <= 0) target.score = this.score+target.score;
					}
				}
			}
		}
		protected function killmyself():void {
				if (!finishTime.running) {
					finishTime.start();
				}
				else {
					alpha = (7 - finishTime.currentCount) / 7;
					if (alpha <= 0.3)	died = true;
				}
		}
		
		private function visibility():void {
				var V_dg:Boolean = x + di > -parent.parent.x && x - di < 800 - parent.parent.x;
				var V_hb:Boolean = y + T > -parent.parent.y && y - hi < 480 - parent.parent.y;
				if ( V_dg && V_hb) visible = true;  else visible = false;
				
		}
		protected function moveEnemy():void {
				x += speed * sens;
				var C:int = (x + di * sens) / T;
				visibility();
				Cl = checkLateral( C);
				var Co:int = Cl[0] / T;var Ls:int = (y + T - 1) / T;
				if (checkSlopes( blocstock[Ls][Co], blocstock[Ls][Co], Ls, Co)) 	 	return	;
				
				y += gravite; 							// déplace le perso sur Y
				if (checkFall( Cl[1], di)) return ;
				if (checkRoof( (y - hi) / T, Cl[0], di)) return;
				// gravite
				if (gravite++ > T) gravite = T;							// limite la gravité max à la taille d'une tuile
		}
		
		
		override public function setTarget(t:CharObj):void {
			target = t;
		}
		
	}
	
	
}