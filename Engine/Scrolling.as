package engine {
	import character.playable.Jackal;
	import flash.display.Sprite;
	import solid.decor.Tuiles;
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
		private var Gy:int = 	15;		
		private var cX:int = 	Gx / 2;	
		private var cY:int = 	Gy / 2;	
		private var Gw:int ;					
		private var Gh:int ;
		private var Li:int=0 ;
		private var Co:int=0 ;
		//----------------------------------------------------------------
		
		public function Scrolling() {
		}
		
		public function initialise(j:Jackal,bs:Array):void {
			jackal = j;
			blocStock = bs;
			//enemyStock = Carte.enemyStock;
			//enemyLayer = Carte.enemyLayer;
			mapH = blocStock.length;
			mapW = blocStock[1].length;
			H = mapH * T;
			W = mapW * T;
			Gw = Gx * T;					
			Gh = Gy * T;
		}
		public function initLayer(g:Sprite,ol:Sprite):void {
			objLayer = ol;
			grille = g;
		}
		public function creeZone():Array{
			var i:int													// colonnes d'affichage (grille)
			var j:int													// lignes d'affichage (grille)
			var I:int													// colonnes de la map
			var J:int													// lignes de la map
			var f:int													// frame à afficher
			objStock = new Array(17);
			for ( i = 0; i < 17; i++ ) { objStock[i] = new Array(26); }
			
			if(mapW>Gx){												// si la map est plus large que la zone d'affichage
				if (jackal.x<cX*T) I = 0									// si le héro est près du bord gauche le premier rondin de la map est le bord gauche
				else if (jackal.x>W-cX*T) I = mapW-Gx-1					// si le héro est près du bord droit le premier rondin de la map est le bord droit moins la largeur de la zone d'affichage
				else I = int(jackal.x/T)-cX								// si le héro est entre les deux le premier rondin de la map est à la position du héro moins la moitié de la largeur de la zone d'affichage
			}
			for (i=0; i<Gx+1; i++){										// boucle sur les colonnes d'affichage
				J=0														// par défaut le premier rrondin ligne est à calé à 0
				if(mapH>Gy){											// si la map est plus haute que la zone d'affichage
					if (jackal.y<cY*T) J=0								// si le héro est près du bord haut le premier rondin de la map est le bord haut
					else if (jackal.y>H-cY*T) J=mapH-(Gy+1)				// si le héro est près du bord bas le premier rondin de la map est le bord bas moins la hauteur de la zone d'affichage
					else J=int(jackal.y/T)-cY							// si le héro est entre les deux le premier rondin de la map est à la position du héro moins la moitié de la hauteur de la zone d'affichage.
				}
				for (j=0; j<Gy+1; j++){									// boucle sur les lignes de chaque colonne d'affichage
					var t:Tuiles = new Tuiles()							// crée une tuile
					t.x= I*T;											// position sur X
					t.y= J*T;											// position sur Y
					t.name = "t_"+j+"_"+i								// nom de la tuile
					objLayer.addChild(t);
					objStock[j][i] = t;// ajout de la tuile à la grille
					if(blocStock[J] && blocStock[J][I]){							// 
						f = blocStock[J][I].fr									// frame à afficher
						if (f>0) t.gotoAndStop(f)							// affiche la bonne image
						else t.gotoAndStop("vide");
					}
					J++													// incrémente la ligne du stock
				}
				I++														// incrément la colonne du stock
			}
			return objStock;
		}
		
		public function run():void{
			var C:int=0;													// ligne d'affichage
			var L:int=0;													// colonne d'affichage
				
			if(mapW>Gx){													// si la map est plus large que la zone d'affichage
				var X:Number = 		jackal.x;								// position du héro sur X
				var minX:Number = 	Gx*dT									// position minimale du scrolling sur X
				var maxX:Number = 	blocStock[0].length*T-minX					// position maximale du scrolling sur X
				if(X>=minX && X<=maxX){										// si le héro n'est pas près d'un bord
					grille.x = -X+minX										// scrolling de la grille sur X
					while (C<Gx+1){											// tant que la colonne est inférieure au nombre de colonnes max de la zone d'affichage
						with (objLayer.getChildByName("t_0_"+C)){				// avec chaque colonnes de la ligne 0
							if (x+grille.x<-T){	// si elle sort à gauche
								changeColonne(C,x+Gw+T,-grille.x/T+Gx);		// replace la colonne à droite
								break;										// stoppe la boucle
							}
							if (x+grille.x>Gw){								// si elle sort à droite
								changeColonne(C,x-Gw-T,-grille.x/T);		// replace la colonne à gauche
								break;										// stoppe la boucle
							}
						}
						C++													// incrémente les colonnes
					}
				}
			}
			
			if(mapH>Gy){													// si la map est plus haute que la zone d'affichage
				var Y:Number = 		jackal.y;								// position du héro sur Y
				var minY:Number = 	Gy*dT									// position minimale du scrolling sur Y
				var maxY:Number = 	blocStock.length*T-minY						// position maximale du scrolling sur Y

				if(Y>=minY && Y<=maxY){										// si le héro n'est pas près d'un bord 
					grille.y = -Y+minY										// scrolling de la grille sur Y
					while (L<Gy+1){											// tant que la ligne est inférieure au nombre de lignes max de la zone d'affichage
						with (objLayer.getChildByName("t_"+L+"_0")){			// avec chaque lignes de la colonne 0
							if (y+grille.y<-T){								// si elle sort en haut
								changeLigne(L,y+Gh+T,-grille.y/T+Gy);		// replace la ligne en bas
								break;										// stoppe la boucle
							}	
							if (y+grille.y>Gh){								// si elle sort en bas
								changeLigne(L,y-Gh-T,-grille.y/T);			// replace la ligne en haut
								break;										// stoppe la boucle
							}
						}
						L++													// incrémente les lignes
					}
				}
			}
		}

		// replace une colonne
		private function changeColonne(C:int,P:Number,X:int):void{
			var L:int=Gy+1;
			var f:int
			while (L--) {
				with (objLayer.getChildByName("t_"+L+"_"+C)){
					x = P;		
					f = blocStock[int(y/T)][X].fr
					if(f>0) gotoAndStop(f) else gotoAndStop("vide")
				}
			}
		}
		 
		// replace une ligne
		private function changeLigne(L:int,P:Number,Y:int):void{
			var C:int=Gx+1;
			var f:int
			while (C--) {
				with (objLayer.getChildByName("t_"+L+"_"+C)){
					y = P;					
					f = blocStock[Y][int(x/T)].fr
					if(f>0) gotoAndStop(f)	else gotoAndStop("vide")
				}
			}
		}
		
		
	}
	
}