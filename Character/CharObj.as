package character {
	import engine.Carte;
	import flash.display.MovieClip;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.utils.Timer;
	import solid.decor.Bloc;
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
		protected var blocstock:Array;
		protected var objStock:Array;
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
		public function init(tb:Array,os:Array):void {
			tabFire = tb;
			objStock = os;
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
				filters = [myBevel];
			}
			else {
				imunTime.reset();
				filters=[];
			}
		}
		protected function checkLateral(C:int):Array {
			var L:int;var L1:int = (y - hi) / T;var L2:int = y / T + 1;
			
			for (L=L1; L<L2; L++) {
				if (blocstock[L][C].fr) {
				if (blocstock[L][C].solide) {				
					checkLateral_sub1(L,C);// si le bord renconte un bloc solide en latéral (prévoir multiples Bloc)
					}
				else	if (blocstock[L][C].item && !hostile) {
					checkLateral_sub2(L,C);
				}
			}
			}
			return[x, L];	
		}
		private function checkLateral_sub1(L:int,C:int) {
			if(blocstock[L][C].destruct){
				if (aT) {
					aT = false;
					blocstock[L][C].resist = blocstock[L][C].resist - force[0] - force[1];
					if (blocstock[L][C].resist <= 0) {
					if (life+blocstock[L][C].life < 100) life = life+blocstock[L][C].life;
					else life = 100;
					if (power+blocstock[L][C].power < 75) power = power + blocstock[L][C].power;
					else power = 75;
					score = score+blocstock[L][C].score;
					//t.unleash();
					blocstock[L][C] = [];
					removeBox(L,C);						
					}
				}
			}
			if (sens == 1) x = C * T - di;
			else if (sens == -1) x = C * T + di+ T;				
		}
		private function checkLateral_sub2(L:int,C:int) {
			
			if (this.life+blocstock[L][C].life < 100) this.life = life+blocstock[L][C].life;
			else life = 100;
			if (power+blocstock[L][C].power < 75) power = power + blocstock[L][C].power;
			else power = 75;
			score = score+blocstock[L][C].score;
			//t.unleash();
			blocstock[L][C] = [];	
			removeBox(L,C);
		}
		protected function removeBox(L:int, C:int) {
			C= (C % 26);
			L = (L % 16);
			objStock[L][C].gotoAndStop("vide");
		}
		protected function addBox(L:int, C:int,fr:int) {
			C= (C % 26);
			L = (L % 16);
			objStock[L][C].gotoAndStop(fr);
		}
		protected function checkFall(L:int,di:int):Boolean {
			var i:int;
			var a:Boolean = false;
			// tombe
			var i2:int = (x - di) / T;
			var i3:int = (x + di) / T;
			for (i = i2; i < i3; i++) {
				if (blocstock[L][i].fr) {
					if (blocstock[L][i].item&&!hostile) {
							if (life+blocstock[L][i].life < 100) life = life+blocstock[L][i].life;
							else life = 100;
							if (power+blocstock[L][i].power < 75) power = power + blocstock[L][i].power;
							else power = 75;
							//t.unleash();
							blocstock[L][i]=[];
							removeBox(L,i);
						}// vérifies toutes colonnes (grille) sur lsquelles se tient le perso	
					else if (blocstock[L][i].solide && y>=(L-1)* T&&!blocstock[L][i].jumper) {			// blocs solides
						y = (L-1)* T									// position du perso sur Y
						gravite = -int(pulse) * jumpPuls;			// annule et autorise le saut
						a = true;return a;
					}
					else if (blocstock[L][i].solide && y >= (L - 1) * T && blocstock[L][i].jumper){
						y = (L-1)* T									// position du perso sur Y
						gravite = - blocstock[L][i].upPulse;			// annule et autorise le saut
						a = true;return a;
					}
					else if ( blocstock[L][i].cloud&&!cloudfall &&gravite>=0 && y >= (L - 1) * T && ! blocstock[L][i].jumper){
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
			var t:Bloc;
			if (gravite<0) {		// si le perso saute
				for (i=(X-di)/T; i<(X+di)/T; i++) {
					if (blocstock[H][i].fr) {
						if (blocstock[H][i].item&&!hostile) {
							if (life+blocstock[H][i].life < 100) life = life+blocstock[H][i].life;
							else life = 100;
							if (power+blocstock[H][i].power < 75) power = power + blocstock[H][i].power;
							else power = 75;
							score = score+blocstock[H][i].score;
							//t.unleash();
							removeBox(H,i);
							blocstock[H][i]=[];
						}
						else if (blocstock[H][i].solide) {							// si la case n'est pas vide
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
			var le:int = blocstock.length;	
			if (gravite>0){
					if (B.slope==-1 && y>=(L-C-1)* T-x && hit((L-C-1)* T+x-di,true)) 	        return true
					if (B.slope==1 && y>=(L+C+1)* T-x && hit((L+C)* T-x+di,true)) 	        return true		
				} else if (gravite==0){
					for (var i:int=0;i<2;i++){	
						if (L+i<le){	
						if (blocstock[L+i][C].slope==-1 && hit((L+i-C-1)* T+x-di,true)) 	return true
						if (blocstock[L+i][C].slope==1 && hit((L+i+C)* T-x-di,true))      return true				
						}
					}
					if (B.solide && !blocstock[L-1][C].solide && hit((L-1)* T+di)) 		return true
					if ((blocstock[L][C+1].slope==1 || blocstock[L][C-1].slope==-1) && hit(L* T)){		
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