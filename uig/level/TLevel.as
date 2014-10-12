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
	import solid.decor.Bloc;
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
		private var controller:Controller = new Controller();
		private var enemyStock:Array;
		private var objStock:Array;
		private var blocStock:Array;
		private var tabFire:Array=new Array();
		protected var player:Jackal;
		private var scrolling:Scrolling = new Scrolling();

		private var gameicon:GameIcon;
		private var lifebar:LifeBar;
		private var powerBar:PowerBar;
		private var Iscore:Score;
		private var T:int=32;

		private var Interface:Sprite = new Sprite();
		private var grille:Sprite = new Sprite();
		private var objLayer:Sprite = new Sprite();
		private var enemyLayer:Sprite = new Sprite();
		private var effectLayer:Sprite = new Sprite();
		
		// grille d'affichage	
		// crée le perso
		public function TLevel() {
		}
		protected function BitInit():void {
			createDecor();
			player = new Jackal(blocStock);						
			createEnemy();
			moteur.initialise(player, enemyStock,scrolling);
			moteur.initLayer(enemyLayer);
			scrolling.initialise(player, blocStock, objStock, grille);
			scrolling.initLayer(objLayer);
			controller.initialise(player);
			initInterface();
		}
		private function initInterface():void {
			gameicon = new GameIcon();
			lifebar = new LifeBar(player);
			powerBar = new PowerBar(player);
			Iscore=new Score(player,0);
			gameicon.x = gameicon.y =0;
			lifebar.alpha = 0.6;lifebar.x = 80;lifebar.y = 20;lifebar.alpha = 0.65;
			powerBar.x = 80;powerBar.y = 25 + lifebar.height;powerBar.alpha = 0.65;
			Iscore.x = 600; Iscore.y = 10;
			
		}
		
		protected function createInterface():void {
			Interface.addChild(lifebar);Interface.addChild(powerBar);Interface.addChild(Iscore);Interface.addChild(gameicon);
		}
		protected function AddAllLayers():void {
			//stage.quality = "LOW";
			addChild(grille)						// ajoute le décor 
			grille.addChild(objLayer)							// ajoute le perso
			grille.addChild(enemyLayer);
			grille.addChild(player);// ajoute le perso
			grille.addChild(effectLayer);// ajoute le perso
			stage.addChild(Interface);
			player.init(tabFire);
			for each(var e in enemyStock) e.init(tabFire);	
			controller.run();
			objStock = blocStock = tab_level = tab_enemy = tabFire=null;
		}
		private function createDecor():void {
			var i,j:int; var t:Tuiles; var b:Bloc;
			var tl = tab_level.length;
			var tl2 = tab_level[0].length;
			objStock = new Array(17);
			blocStock = new Array(tl);
			for ( i = 0; i < 17; i++ ) { objStock[i] = new Array(25); }
			for ( i = 0; i < tl; i++ ) { blocStock[i] = new Array(tl2); }
			// création du level
			for (i=0; i<17; i++){					// boucle sur les 20 colonnes
				for (j=0; j<26; j++){				// boucle sur les 15 lignes de chaque colonne
						t = new Tuiles();
						t.x = j * T; t.y = i * T;
						if (tab_level[i][j] > 0) t.gotoAndStop(tab_level[i][j]);			// frame à afficher
						else { t.gotoAndStop("vide"); }
						objStock[i][j] = t;
						objLayer.addChild(t);					// ajout dela tuile à la grille
				}
			}
			
			for (i=0; i<tl; i++){					// boucle sur les 20 colonnes
				for (var j:int=0; j<tl2; j++){				// boucle sur les 15 lignes de chaque colonne
					if(tab_level[i][j]>0){// si la valeur de la tuile est supérieure à 0
					b = new Bloc();
					// crée une tuile
					speBloc(b, tab_level[i][j]);
					b.fr= tab_level[i][j];
					blocStock[i][j] = b;
					}
					else blocStock[i][j] = [];// ajout dela tuile à la grille
				}
			}
		}
		
		private  function speBloc(s:Bloc,n:int):void {
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
			return ;
		}
		private function createEnemy():void {
			var i:int;
			enemyStock = new Array(tab_enemy.length);
			var e1:NormalFarmer ;var e2:BuilderFarmer;var e3:Goat ;
			var tl:int = tab_enemy.length;
			for (i = 0; i < tl; i++ ) {
				if (tab_enemy[i][2] == 1) {
					e1= new NormalFarmer(blocStock);			//
					e1.x = tab_enemy[i][0]; e1.y = tab_enemy[i][1]; e1.IAtype = tab_enemy[i][3]; e1.Etype = tab_enemy[i][2]; e1.setTarget(player); e1.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e1.burning);
					enemyStock[i] = e1;	enemyLayer.addChild(e1);
				}
				if (tab_enemy[i][2] == 2) {
					e2= new BuilderFarmer(blocStock);			//
					e2.x = tab_enemy[i][0];	e2.y = tab_enemy[i][1];	e2.IAtype = tab_enemy[i][3];e2.Etype = tab_enemy[i][2];	e2.setTarget(player);e2.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e2.burning);
					enemyStock[i] = e2;	enemyLayer.addChild(e2);
				}
				if (tab_enemy[i][2] == 3) {
					e3= new Goat(blocStock);	e3.x = tab_enemy[i][0];e3.y = tab_enemy[i][1];e3.IAtype = tab_enemy[i][3];e3.Etype = tab_enemy[i][2];e3.setTarget(player);e3.InPos = [tab_enemy[i][0], tab_enemy[i][1]];
					//Carte.effectLayer.addChild(e3.burning);
					enemyStock[i] = e3;
					enemyLayer.addChild(e3);
				}
			}
		}
		
		
	}
	
	
	
}
