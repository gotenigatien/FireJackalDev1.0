package engine {
	import character.playable.Jackal;
	import flash.display.Sprite;
	public class Scrolling {
		
		private var jackal:Jackal;
		private var objLayer:Sprite;
		private var blocStock:Array;
		private var objStock:Array;
		private var grille:Sprite;
		private var mapW:int;
		private var mapH:int;
		private var W:int;
		private var H:int;
		private var T:int=32;
		private var dT:int=16;
		//-------------------------------------------------------------				
		// constantes de la partie
		private var Gx:int =	25	;	
		private var Gy:int = 	16;		
		private var cX:int = 	Gx / 2;	
		private var cY:int = 	Gy / 2;	
		private var Gw:int ;					
		private var Gh:int ;
		private var Li:int=0 ;
		private var Co:int=0 ;
		private	var Ld:int;
		private var lane:int ;
		//----------------------------------------------------------------
		
		public function Scrolling() {
		}
		
		public function initialise(j:Jackal,bs:Array,os:Array,g:Sprite):void {
			jackal = j;
			blocStock = bs;
			grille = g;
			objStock = os;
			//enemyStock = Carte.enemyStock;
			//enemyLayer = Carte.enemyLayer;
			mapH = blocStock.length;
			mapW = blocStock[1].length;
			H = mapH * T;
			W = mapW * T;
			Gw = Gx * T;					
			Gh = Gy * T;
			lane = blocStock[0].length - objStock[0].length;
		}
		public function initLayer(ol:Sprite):void {
			objLayer = ol;
		}
		/*
		public function creeZone():void{ 
			var i, j, I, J, f:int;
			
			if(mapW>Gx){
				if (jackal.x<cX*T) I = 0
				else if (jackal.x>W-cX*T) I = mapW-Gx-1
				else I = int(jackal.x/T)-cX
			}
			for (i=0; i<Gx+1; i++){		
				J=0
				if(mapH>Gy){
					if (jackal.y<cY*T) J=0
					else if (jackal.y>H-cY*T) J=mapH-(Gy+1)
					else J=int(jackal.y/T)-cY
				}
				for (j=0; j<Gy+1; j++){			
					objStock[J][I].name = "t_"+j+"_"+i
					if(objStock[J] && objStock[J][I]){
						//f = objStock[J][I].fr; 
					}
					J++
				}
				I++
			}

		}
		*/
		public function run():void {
			var C:int=0;
			var B:int=0;
			var L:int = 0;
			if(mapW>Gx){
				var X:Number = 	 	jackal.x;
				var minX:Number = 	Gx * dT;
				var maxX:Number = 	blocStock[0].length * T - minX;		
				var a:int = 0;
				if(X>=minX && X<=maxX){
					grille.x = -X + minX;
					//if (Li >= Gx) Li = 0;	
					while (C < Gy+1) { 
						if (objStock[C][Li].x + grille.x < -T) { 
							objStock[C][Li].x = Gw + Li*T +T;
							if(blocStock[C][1+Li+Gx].fr>0)objStock[C][Li].gotoAndStop(blocStock[C][1+Li+Gx].fr);
							else objStock[C][Li].gotoAndStop("vide");
							a++;
						}
						C++;
					}if (a == C-1) { a = 0; if (Li < lane)  Li++;
									
					}Ld = Li;
					while (B < Gy + 1) { trace("ok");
						if (objStock[B][Ld].x + grille.x > Gw) {
							
							objStock[B][Li].x = objStock[B][Li].x - Gw - T*Li+T;
							/*if(blocStock[B][Li].fr>0)objStock[B][Li].gotoAndStop(blocStock[B][Li].fr);
							else objStock[B][Li].gotoAndStop("vide");*/
							a++;
						}	
						B++; 
					}
					//if (a == C) { a = 0; if (Li > 0) Li--; }
						
					 /*
					 */
					/*					 
					*/
					//objStock[L][X].fr
				}
			}
			if(mapH>Gy){
				var Y:Number = 	 	jackal.y;
				var minY:Number = 	Gy * dT;
				var maxY:Number =  blocStock.length * T - minY;
				if(Y>=minY && Y<=maxY){
					grille.y = -Y + minY;
				}
			}	
		}
		
		// replace une colonne
		function changeColonne(C:int,P:Number,X:int):void{
			var L:int=Gy+1;
			var f:int
			while (L--) {
				with (objLayer.getChildByName("t_"+L+"_"+C)){
					x = P;		
					f = objStock[int(y/T)][X]
					if(f>0  && f!=12) gotoAndStop(f) else gotoAndStop("vide")
				}
			}
		}
		 /*
		// replace une ligne
		function changeLigne(L:int,P:Number,Y:int):void{
			var C:int=Gx+1;
			var f:int
			
			while (C--) {
				with (objLayer.getChildByName("t_"+L+"_"+C)){
					y = P;					
					f = objStock[Y][int(x/T)]
					if(f>0 && f!=12) gotoAndStop(f)	else gotoAndStop("vide")
				}
			}
		}
		*/
		
	}
	
}