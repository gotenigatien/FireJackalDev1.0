package Character {
	import Character.Effect.Jackal.Burning;
	import flash.display.MovieClip;
	import Engine.Carte;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.utils.Timer;
	import Solid.Decor.Tuiles;
	public class CharObj extends MovieClip{
		//-----------------------------------------------------
		public var score:int;//A MODIFIER !!!!
		//-------------------------------------------------
		public var gravite:Number;					// la gravité du jeu
		public var speed:Number;					// la vitesse du héro
		public var sens:Number; 					// la direction du héro sur X
		protected var sloping:Boolean=false;
		protected var cloudfall:Boolean = false;
		public var aT:Boolean = false;
		public var powerattack:Boolean = false;
		public var attackPrior:int=0;
		public var force:Array = new Array(0, 0);
		public var imunTime:Timer = new Timer(100,5);
		public var imunity:Boolean=false;
		public var life:int;
		public var power:int;
		public var di:int;
		public var hi:int;
		public var pulse:Boolean = false;
		public var jumpPuls:Number;
		public var die:Boolean;
		public var died:Boolean;
		public var hostile:Boolean = false;
		//public var Afilters:Array = new Array();
		private var myBevel:BevelFilter; 
		//----------------------------------------------------------------------------------------
		protected var T:int;
		protected var objstock:Array;
		//protected var enemyLayer:Sprite;
		protected var objLayer:Sprite;
		protected var effectLayer:Sprite;
		protected var tabFire:Array;
		public function CharObj() {
			T = Carte.T;
			//----------------------------------------------
			/*
			myBevel = new BevelFilter();
			myBevel.type = BitmapFilterType.INNER;
			myBevel.distance = 6;
			myBevel.highlightColor =0xDE3F3F;  
			myBevel.shadowColor = 0xDE3F3F;   
			myBevel.blurX = 1;    
			myBevel.blurY = 1;
			*/
		}
		public function init():void {
			objLayer = Carte.objLayer;
			effectLayer = Carte.effectLayer;
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
				alpha = 1 - 0.65 * int(imunTime.currentCount % 2 != 0);
				//filters =[myBevel];
			}
			else {
				imunTime.reset();
			//	filters=[];
			}
		}
		
		protected function checkLateral(C:int):Array {
			var dx:int = sens;										// ligne (grille) du point bas du perso
			// raccourci de programmation pour persx
			// latéral	
			var L:int;						// côté (grille) du perso concerné par la colission
			// latéral	
			var L1:int=(y-hi)/T
			var L2:int = y / T + 1;
			for (L=L1; L<L2; L++) {					// vérifies toutes lignes (grille) sur lesquelles se tient le perso
				if (objstock[L][C].solide) {								// si le bord renconte un bloc solide en latéral (prévoir multiples tuiles)
					// colle le perso au bord du bloc
					if(objstock[L][C].destruct){
						if (aT) {
							aT = false;
							objstock[L][C].resist = objstock[L][C].resist - force[0] - force[1];
							if (objstock[L][C].resist <= 0) {
								if (life+objstock[L][C].life < 100) life = life+objstock[L][C].life;
								else life = 100;
								if (power+objstock[L][C].power < 75) power = power + objstock[L][C].power;
								else power = 75;
								score = score+objstock[L][C].score;
								objLayer.removeChild(objstock[L][C]);
								objstock[L][C]=[];
							}
						}
					}
					if (sens == 1) x = C * T - di;
					if (sens == -1) x = C * T + di+ T;
					
				}
				if (objstock[L][C].item && !hostile) {
					if (life+objstock[L][C].life < 100) life = life+objstock[L][C].life;
					else life = 100;
					if (power+objstock[L][C].power < 75) power = power + objstock[L][C].power;
					else power = 75;
					score = score+objstock[L][C].score;
					objLayer.removeChild(objstock[L][C]);
					objstock[L][C]=[];
				}
			}
			return[x, L];	
		}
		
		protected function checkFall(L:int,X:Number,di:int):Boolean {
			var i:int;
			var a:Boolean = false;
			// tombe
			for (i=(x-di)/T; i<(x+di)/T; i++) {
				if (objstock[L][i].item&&!hostile) {
						if (life+objstock[L][i].life < 100) life = life+objstock[L][i].life;
						else life = 100;
						if (power+objstock[L][i].power < 75) power = power + objstock[L][i].power;
						else power = 75;
						objLayer.removeChild(objstock[L][i]);
						objstock[L][i]=[];
					}// vérifies toutes colonnes (grille) sur lsquelles se tient le perso	
				else if (objstock[L][i].solide && y>=(L-1)* T&&!objstock[L][i].jumper) {			// blocs solides
					y = (L-1)* T									// position du perso sur Y
					gravite = -int(pulse) * jumpPuls;			// annule et autorise le saut
					a = true;
					return a;
				}
				else if (objstock[L][i].solide && y >= (L - 1) * T && objstock[L][i].jumper){
					y = (L-1)* T									// position du perso sur Y
					gravite = - objstock[L][i].upPulse;			// annule et autorise le saut
					a = true;
					return a;
				}
				else if (objstock[L][i].cloud&&!cloudfall &&gravite>=0 && y >= (L - 1) * T && !objstock[L][i].jumper){
					y = (L-1)* T									// position du perso sur Y
					gravite = -int(pulse) * jumpPuls;			// annule et autorise le saut
					a = true;
					return a;
				}
			}
			return a;
		}
		
		protected function checkRoof(H:int, X:Number, di:int):Boolean{
			// touche plafond
			var i:int;
			var a:Boolean = false;
			if (gravite<0) {									// si le perso saute
				for (i=(X-di)/T; i<(X+di)/T; i++) {				// cases occupées par les limites X du perso
					if (objstock[H][i].item&&!hostile) {
						if (life+objstock[H][i].life < 100) life = life+objstock[H][i].life;
						else life = 100;
						if (power+objstock[H][i].power < 75) power = power + objstock[H][i].power;
						else power = 75;
						score = score+objstock[H][i].score;
						objLayer.removeChild(objstock[H][i]);
						objstock[H][i]=[];
					}
					else if (objstock[H][i].solide) {							// si la case n'est pas vide
						y = (H+2)* T-hi					// position du perso sur Y
						gravite = 1;								// arrête le saut
						a = true;
						return a;
					}
				}
			}
			return a;					
		}
		
		protected function checkSlopes(A:Object, B:Object, L:int, C:int):Boolean {
				if (gravite>0){
					if (B.slope==-1 && y>=(L-C-1)* T-x && hit((L-C-1)* T+x-di,B.slope,true)) 	        return true
					if (B.slope==1 && y>=(L+C+1)* T-x && hit((L+C)* T-x+di,B.slope,true)) 	        return true		
				} else if (gravite==0){
					for (var i:int=0;i<2;i++){	
						if (L+i<objstock.length){	
						if (objstock[L+i][C].slope==-1 && hit((L+i-C-1)* T+x-di,objstock[L+i][C].slope,true)) 	return true
						if (objstock[L+i][C].slope==1 && hit((L+i+C)* T-x-di,objstock[L+i][C].slope,true))      return true				
						}
					}
					if (B.solide && !objstock[L-1][C].solide && hit((L-1)* T+di,B.slope)) 		return true
					if ((objstock[L][C+1].slope==1 || objstock[L][C-1].slope==-1) && hit(L* T,B.slope)){		
						if (!A.jumper && A.solide)			        return true
					}
				} 
				sloping=false
			return false
		}
		
		protected function hit(Y:Number,next:int=0,S:Boolean=false):Boolean{
			//rotation=-45*next*int(gravite>=0);
			y = Y		
			gravite =-int(pulse) * jumpPuls;
			sloping = S&&!pulse			
			return true				
		}
		
		
	}
}