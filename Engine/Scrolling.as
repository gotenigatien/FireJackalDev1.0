package Engine {
	import Character.Playable.Jackal;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Solid.Decor.Tuiles;
	public class Scrolling {
		
		private var jackal:Jackal;
		private var map:Array;
		private var objStock:Array;
		private var grille:Sprite;
		private var mapW:int;
		private var mapH:int;
		private var W:int;
		private var H:int;
		private var T:int;
		private var dT:int;
		//-------------------------------------------------------------				
		// constantes de la partie
		private var Gx:int =	24		
		private var Gy:int = 	15		
		private var cX:int = 	Gx / 2;	
		private var cY:int = 	Gy / 2;	
		private var Gw:int ;					
		private var Gh:int ;
		//----------------------------------------------------------------
		
		public function Scrolling() {
		}
		
		public function initialise(j:Jackal,m:Array,os:Array,g:Sprite):void {
			jackal = j;
			map = m;
			grille = g;
			objStock = os;
			//enemyStock = Carte.enemyStock;
			//enemyLayer = Carte.enemyLayer;
			mapH = map.length;
			mapW = map[1].length;
			T = Carte.T;
			dT = Carte.T * 0.5;
			H = mapH * T;
			W = mapW * T;
			Gw = Gx * T;					
			Gh = Gy * T;
		}
		
		public function creeZone():void{ 
			var i:int
			var j:int
			var I:int
			var J:int
			var f:int
		 
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
						f = objStock[J][I].fr; 
					}
					J++
				}
				I++
			}

		}
		public function run():void {
			var C:int=0;
			var L:int=0;
		 
			if(mapW>Gx){
				var X:Number = 	 	jackal.x;
				var minX:Number = 	Gx * dT;
				var maxX:Number = 	map[0].length * T - minX;				
				if(X>=minX && X<=maxX){
					grille.x = -X + minX;
				}
			}
			if(mapH>Gy){
				var Y:Number = 	 	jackal.y;
				var minY:Number = 	Gy * dT;
				var maxY:Number = 	map.length * T - minY;
				if(Y>=minY && Y<=maxY){
					grille.y = -Y + minY;
				}
			}	
		}
		 
		
	}
	
}