package uig.level {
	import character.enemy.BuilderFarmer;
	import character.enemy.Goat;
	import character.enemy.NormalFarmer;
	import character.playable.Jackal;
	import engine.Carte;
	import engine.Controller;
	import engine.Moteur;
	import engine.Scrolling;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import solid.decor.Tuiles;
	import tools.library.CSV;
	import uig.uig.GameIcon;
	import uig.uig.LifeBar;
	import uig.uig.PowerBar;
	import uig.uig.Score;
	
	
	public class TLevel extends MovieClip {
		
		
		protected var tab_level:Array;
		protected var tab_enemy:Array;
		protected var csvlib:CSV;
		protected var moteur:Moteur = new Moteur();
		protected var controller:Controller = new Controller();
		protected var enemyStock:Array;
		protected var objStock:Array;
		protected var player:Jackal;
		protected var scrolling:Scrolling = new Scrolling();

		private var gameicon:GameIcon;
		private var lifebar:LifeBar;
		private var powerBar:PowerBar;
		private var Iscore:Score;
		protected var T:int;

		private var Interface:Sprite = new Sprite();

		protected var grille:Sprite = new Sprite();
		private var objLayer:Sprite = new Sprite();
		private var enemyLayer:Sprite = new Sprite();
		private var effectLayer:Sprite = new Sprite();
		
		// grille d'affichage	
		// crée le perso
		public function TLevel() {
			T = Carte.T;
		}
		
		protected function initInterface():void {
			gameicon = new GameIcon();
			lifebar = new LifeBar(player);
			powerBar = new PowerBar(player);
			Iscore=new Score(player,0);
			gameicon.x = gameicon.y =0;
			lifebar.alpha = 0.6;lifebar.x = 80;lifebar.y = 20;lifebar.alpha = 0.65;
			powerBar.x = 80;powerBar.y = 25 + lifebar.height;powerBar.alpha = 0.65;
			Iscore.x=600;Iscore.y=10;
		}
		
		protected function createInterface():void {
			Interface.addChild(lifebar);Interface.addChild(powerBar);Interface.addChild(Iscore);Interface.addChild(gameicon);
		}
		protected function AddAllLayers():void {
			addChild(grille)						// ajoute le décor 
			grille.addChild(objLayer)							// ajoute le perso
			grille.addChild(enemyLayer);
			grille.addChild(player);// ajoute le perso
			grille.addChild(effectLayer);// ajoute le perso
			stage.addChild(Interface);
			Carte.grille = grille;Carte.objLayer = objLayer;Carte.enemyLayer = enemyLayer;Carte.tabFire = new Array();Carte.effectLayer = effectLayer;
			player.init();
			for each(var e in enemyStock) e.init();
			
		}
		protected function createDecor():void {
			var i:int; var t:Tuiles;
			var tl = tab_level.length;
			var tl2 = tab_level[i].length;
			objStock = new Array(tl);
			for ( i = 0; i < tl; i++ )objStock[i] = new Array(tl2);
			// création du level
			for (i=0; i<tl; i++){					// boucle sur les 20 colonnes
				for (var j:int=0; j<tl2; j++){				// boucle sur les 15 lignes de chaque colonne
					if(tab_level[i][j]>0)	{						// si la valeur de la tuile est supérieure à 0
						t = new Tuiles();			// crée une tuile
						t.x = j * T;t.y = i * T;
						t = speDecor(t, tab_level[i][j]); t.fr = tab_level[i][j];if (t.fr > 0) t.gotoAndStop(t.fr);			// frame à afficher
						objStock[i][j] = t;
						objLayer.addChild(t);					// ajout dela tuile à la grille
					}
					else objStock[i][j] = []
					
				}
			}
		}
		
		private  function speDecor(s:Tuiles,n:int ):Tuiles {
			switch(n) {
				case 1:
				s.solide = true;	
				break;
				case 2:
				s.slope = -1;s.gradient = 45;
				break;
				case 3:
				s.slope = 1;s.gradient = 45;
				break;
				case 4:
				s.slope = -2;s.gradient = 45;
				break;
				case 5:
				s.slope = 2;s.gradient = 45;
				break;
				case 6:
				s.cloud = true;
				break;
				case 7:
				s.jumper = s.solide = true;s.upPulse = 18;
				break;
				case 8:
				s.item = true;s.life = 10;s.score = 5;
				break;
				case 9:
				s.solide =s.destruct = true;s.resist = 2;	s.score = 5;
				break;
				case 10:
				s.item = true;s.power = 10;	s.score = 5;
				break;
				default:
				break;
			}
			return s;
		}
		
		protected function createEnemy():void {
			var i:int;
			enemyStock = new Array(tab_enemy.length);
			var e1:NormalFarmer ;var e2:BuilderFarmer;var e3:Goat ;
			var tl:int = tab_enemy.length;
			for (i = 0; i < tl; i++ ) {
				if (tab_enemy[i][2] == 1) {
					e1= new NormalFarmer(objStock);			//
					e1.x = tab_enemy[i][0]; e1.y = tab_enemy[i][1]; e1.IAtype = tab_enemy[i][3]; e1.Etype = tab_enemy[i][2]; e1.setTarget(player); e1.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e1.burning);
					enemyStock[i] = e1;	enemyLayer.addChild(e1);
				}
				if (tab_enemy[i][2] == 2) {
					e2= new BuilderFarmer(objStock);			//
					e2.x = tab_enemy[i][0];	e2.y = tab_enemy[i][1];	e2.IAtype = tab_enemy[i][3];e2.Etype = tab_enemy[i][2];	e2.setTarget(player);e2.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e2.burning);
					enemyStock[i] = e2;	enemyLayer.addChild(e2);
				}
				if (tab_enemy[i][2] == 3) {
					e3= new Goat(objStock);	e3.x = tab_enemy[i][0];e3.y = tab_enemy[i][1];e3.IAtype = tab_enemy[i][3];e3.Etype = tab_enemy[i][2];e3.setTarget(player);e3.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e3.burning);
					enemyStock[i] = e3;
					enemyLayer.addChild(e3);
				}
			}
		}
		
		
	}
	
	
	
}
