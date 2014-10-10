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
			for each(i in Carte.tabFire){
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
						if (this.life <= 0) this.score = this.score+target.score;
					}
				}
			}
		}
		protected function killmyself():void {
				if (!finishTime.running) {
					finishTime.start();
				}
				else {
					alpha = (8 - finishTime.currentCount) / 8;
					if (alpha <= 0.3)	died = true;
				}
		}
		protected function moveEnemy():void {
				x += speed * sens;
				var C:int = (x + di * sens) / T; var X:Number;var L:int;
				Cl = checkLateral( C);
				X = Cl[0];L = Cl[1];
				var Co:int = X / T;var Ls:int = (y + T - 1) / T;
				if (checkSlopes( objstock[Ls][Co], objstock[Ls][Co], Ls, Co)) 	 	return	;
				
				y += gravite; 							// déplace le perso sur Y
				if (checkFall( L, di)) return ;
				if (checkRoof( (y - hi) / T, X, di)) return;
				// gravite
				if (gravite++ > T) gravite = T;							// limite la gravité max à la taille d'une tuile
		}
		
		
		override public function setTarget(t:CharObj):void {
			target = t;
		}
		
	}
	
	
}