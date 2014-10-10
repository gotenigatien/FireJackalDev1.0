package character {
	import engine.Carte;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import solid.decor.Tuiles;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	public class CharObj extends MovieClip{
		//-----------------------------------------------------
		public var score:int;//A MODIFIER !!!!
		//-------------------------------------------------
		protected var Cl:Array = new Array();		
		public var gravite:Number;					// la gravité du jeu
		protected var speed:Number;					// la vitesse du héro
		public var sens:Number; 					// la direction du héro sur X
		protected var sloping:Boolean=false;
		protected var cloudfall:Boolean = false;
		public var aT:Boolean = false;
		public var powerattack:Boolean = false;
		//public var attackPrior:int=0;
		public var force:Array = new Array(0, 0);
		public var imunTime:Timer = new Timer(100,5);
		public var imunity:Boolean=false;
		public var life:int;
		public var power:int;
		public var di:int;
		public var hi:int;
		protected var pulse:Boolean = false;
		protected var jumpPuls:Number;
		public var die:Boolean;
		public var died:Boolean;
		protected var hostile:Boolean = false;
		//public var Afilters:Array = new Array();
		private var myBevel:BevelFilter; 
		//----------------------------------------------------------------------------------------
		protected var T:int;
		protected var objstock:Array;
		protected var tabFire:Array;
		public function CharObj() {
			T = Carte.T;
			//----------------------------------------------
			
			myBevel = new BevelFilter();
			myBevel.type = BitmapFilterType.INNER;
			myBevel.distance = 5;
			myBevel.highlightColor =0xFF3F3F;  
			myBevel.shadowColor = 0xFF3F3F;   
			myBevel.blurX = 1;    
			myBevel.blurY = 1;
			
		}
		public function init():void {
			tabFire = Carte.tabFire;
		}
		public function motricite():void {
			
		}
			// animation du perso
		protected function mouvement(mouv):void {
			if (currentFrame != mouv) {				// si le mouvement est différent de celui à effectuer
				gotoAndStop(mouv);					// effectue le nouveau mouvement
			}
		}
		 public function setTarget(t:CharObj):void {
			
		}
		
		protected function hurt():void {
			if (imunTime.running) {
				alpha = 1 - 0.5 * int(imunTime.currentCount % 2 != 0);
				//filters = [myBevel];
			}
			else {
				imunTime.reset();
				//filters=[];
			}
		}
		
		protected function checkLateral(C:int):Array {
			var L:int;var L1:int = (y - hi) / T;var L2:int = y / T + 1;
			
			var t:Tuiles;
			for (L=L1; L<L2; L++) {
				if (objstock[L][C].fr) {t = objstock[L][C];
				if (t.solide) {				
					checkLateral_sub1(t,L,C);// si le bord renconte un bloc solide en latéral (prévoir multiples tuiles)
					}
				else	if (t.item && !hostile) {
					checkLateral_sub2(t,L,C);
				}
			}
			}
			return[x, L];	
		}
		private function checkLateral_sub1(t:Tuiles,L:int,C:int) {
			var dx:int = sens;
			if(t.destruct){
				if (aT) {
					aT = false;
					t.resist = t.resist - force[0] - force[1];
					if (t.resist <= 0) {
					if (life+t.life < 100) life = life+t.life;
					else life = 100;
					if (power+t.power < 75) power = power + t.power;
					else power = 75;
					score = score+t.score;
					t.unleash();
					objstock[L][C] = [];						
					}
				}
			}
			if (dx == 1) x = C * T - di;
			else if (dx == -1) x = C * T + di+ T;				
		}
		private function checkLateral_sub2(t:Tuiles,L:int,C:int) {
			
			if (this.life+t.life < 100) this.life = life+t.life;
			else life = 100;
			if (power+t.power < 75) power = power + t.power;
			else power = 75;
			score = score+t.score;
			t.unleash();
			objstock[L][C]=[];
		}
		protected function checkFall(L:int,di:int):Boolean {
			var i:int;
			var a:Boolean = false;
			// tombe
			var i2:int = (x - di) / T;
			var i3:int = (x + di) / T;
			var t:Tuiles;
			for (i = i2; i < i3; i++) {
				if (objstock[L][i].fr) {t = objstock[L][i];
				if (t.item&&!hostile) {
						if (life+t.life < 100) life = life+t.life;
						else life = 100;
						if (power+t.power < 75) power = power + t.power;
						else power = 75;
						t.unleash();
						objstock[L][i]=[];
					}// vérifies toutes colonnes (grille) sur lsquelles se tient le perso	
				else if (t.solide && y>=(L-1)* T&&!t.jumper) {			// blocs solides
					y = (L-1)* T									// position du perso sur Y
					gravite = -int(pulse) * jumpPuls;			// annule et autorise le saut
					a = true;return a;
				}
				else if (t.solide && y >= (L - 1) * T && t.jumper){
					y = (L-1)* T									// position du perso sur Y
					gravite = - objstock[L][i].upPulse;			// annule et autorise le saut
					a = true;return a;
				}
				else if (t.cloud&&!cloudfall &&gravite>=0 && y >= (L - 1) * T && !t.jumper){
					y = (L-1)* T									// position du perso sur Y
					gravite = -int(pulse) * jumpPuls;			// annule et autorise le saut
					a = true;return a;
				}
				}
			}
			return a;
		}
		
		protected function checkRoof(H:int, X:Number, di:int):Boolean{
			// touche plafond
			var i:int;
			var a:Boolean = false;
			var t:Tuiles;
			if (gravite<0) {		// si le perso saute
				for (i=(X-di)/T; i<(X+di)/T; i++) {
					if (objstock[H][i].fr) { t = objstock[H][i];
						if (t.item&&!hostile) {
							if (life+t.life < 100) life = life+t.life;
							else life = 100;
							if (power+t.power < 75) power = power + t.power;
							else power = 75;
							score = score+t.score;
							t.unleash();
							objstock[H][i]=[];
						}
						else if (t.solide) {							// si la case n'est pas vide
							y = (H+2)* T-hi					// position du perso sur Y
							gravite = 1;								// arrête le saut
							a = true;
							return a;
						}
					}
				}
			}
			return a;					
		}
		
		protected function checkSlopes(A:Object, B:Object, L:int, C:int):Boolean {
			var le:int = objstock.length;	
			if (gravite>0){
					if (B.slope==-1 && y>=(L-C-1)* T-x && hit((L-C-1)* T+x-di,true)) 	        return true
					if (B.slope==1 && y>=(L+C+1)* T-x && hit((L+C)* T-x+di,true)) 	        return true		
				} else if (gravite==0){
					for (var i:int=0;i<2;i++){	
						if (L+i<le){	
						if (objstock[L+i][C].slope==-1 && hit((L+i-C-1)* T+x-di,true)) 	return true
						if (objstock[L+i][C].slope==1 && hit((L+i+C)* T-x-di,true))      return true				
						}
					}
					if (B.solide && !objstock[L-1][C].solide && hit((L-1)* T+di)) 		return true
					if ((objstock[L][C+1].slope==1 || objstock[L][C-1].slope==-1) && hit(L* T)){		
						if (!A.jumper && A.solide)			        return true
					}
				} 
			sloping = false;
			return false;
		}
		
		protected function hit(Y:Number,S:Boolean=false):Boolean{
			//rotation=-45*next*int(gravite>=0);
			y = Y		
			gravite =-int(pulse) * jumpPuls;
			sloping = S&&!pulse			
			return true				
		}
		
		
	}
}