﻿package character.playable {
	
	import character.CharObj;
	import character.effect.jackal.Special_fire;
	import engine.Carte;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import solid.decor.Bloc;
	
	public class Jackal extends CharObj {
		
			
	// variables déplacements
	public var droite:Boolean=false;
	public var gauche:Boolean=false;
	public var haut:Boolean=false;
	public var jumptor:Boolean=false;
	public var tornadeup:Boolean=false;
	public var tornadedown:Boolean=false;
	public var striking:Boolean=false;
	public var balling:Boolean=false;
	public var strikehasard:Number=0;
	public var swipebottom:Boolean=false;
	public var strikefall:Boolean=false;
	public var strikefalling:Boolean=false;
	public var bottom:Boolean=false;
	public var special1:Boolean = false;
	private var runstrike:Boolean = false;
	private var stormup:Boolean = false;
	private var stormdown:Boolean = false;
	
	// variables mouvements
	public var lateral:Boolean = false; 			// mouvement latéral 
	public var saute:Boolean = false ;				// le héro saute
	public var aucune:Boolean = true ; 				// aucune action en cours
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------
		public var jumpTime:Timer=new Timer(140,1);
		public var jumptorTime:Timer=new Timer(130,1);
		public var strikingTime:Timer=new Timer(520,1);
		public var strikefallingTime:Timer=new Timer(400,1);
		public var ballingTime:Timer=new Timer(530,1);
		public var tornadeupTime:Timer=new Timer(330,1);
		public var tornadedownTime:Timer=new Timer(400,1);
		public var bottomTime:Timer=new Timer(500,1);
		public var special1Time:Timer=new Timer(650,1);
	//--------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	public function Jackal(os:Array) {
			blocstock = os;
			// constructor code
			gravite = 1; speed = 4.5; sens = 0;power = 25;di = 24;hi = 16;jumpPuls = 13.5;life = 100;
		}
				
		public function GestureReaction(e:int):void{
			switch (e){
				case 0:
				haut = false;
				balling=false;
				droite=false;
				gauche=false;
				tornadeup=false;
				tornadedown=false;
				break;	
				
				case 1:
				droite=false;
				gauche=false;
				break;
				
				case 2:
				haut=false;
				break;
				case 3:
				break;
			default:
				break;
			}
		}
		
		override public function motricite():void {
			
				// variables
				sens = int(droite)-int(gauche);					// orientation
				aucune = !droite && !gauche && !haut&&!strikefall&&!strikefalling&&!jumptor&&!tornadeup&&!tornadedown&&!bottom&&!special1&&!die; //&& !bas	// aucune action
				lateral = (droite || gauche)&&!striking&&!balling&&!jumptor&&!tornadeup&&!tornadedown&&!bottom&&!special1&&!die;					// mouvement latéral
				cloudfall = bottom||balling;	
				pulse = haut;
				runstrike = !balling && striking && gravite == 0&&!die;
				speed = 5.5 -  1 * int(runstrike) + int(balling);
				stormup = (tornadeup && !tornadedown && !strikefalling&&!die)||(jumptor&&!strikefalling&&!tornadedown&&!die);
				stormdown = tornadedown && !tornadeup && !strikefalling && !strikefall&&!die; 
				hi = 16 - 18 * int(balling) - 18 * int(bottom);
				di = 24 - 8 * int(balling); //- 12 * int(strikefalling)
				hurt();
				die = (life <= 0);
				if (die) {
					pulse = false;
					mouvement(17);
				}
				// mouvements
				if (sens) scaleX = -sens;						// oriente le perso
				if (aucune) mouvement(1);							// repos 
				if (bottom && !strikefall) mouvement(15);							// se baisse 
				
				if (lateral) mouvement(2); 							// droite et gauche
				if (runstrike&&gravite==0) { // attaque course1&2&3
													force=[2, 0];
													if (strikehasard > 0.6 && strikehasard <= 1) { mouvement(6); makedamage(1); }// attaque course1
													if (strikehasard>0.2&&strikehasard<=0.6)	{mouvement(8);makedamage(2); }// attaque course2
													if (strikehasard<=0.2) 					{mouvement(9);makedamage(3); }// attaque course3
													}	
				if (haut) mouvement(3); 								// saute
				if (gravite == 0 && balling&&!die) {
					mouvement(7);
					force = [1, 0];//roule en boule
					makedamage(4);
				}
				if (strikefall&&!tornadedown&&!die)mouvement(11);						//strikefall
				if (special1 && !die) { //special1
					mouvement(16); 
					makedamage(5); 
				}
				if(!strikefall&&!strikefalling&&!jumptor&&!tornadeup&&!tornadedown)
					{
					if (gravite<0&&!haut&&!die) mouvement(5); 					// monte(apres saut)
					if (gravite>0&&!die) mouvement(4); 							// tombe
					// déplacements 
					moveHero(sens);		
					}
				else if(strikefalling&&!die){
					mouvement(10); //Tombe apres strikefall
					force = [0, 3];				
					gauche = droite = false;
					moveHero_strikefalling(sens);
				}
				else if(jumptor&&!strikefalling&&!tornadedown&&!die){
					mouvement(12);						// saut tornade
					moveHero_tornadesideup(sens);
				}
				else if(tornadeup&&!tornadedown&&!strikefalling&&!die){
					mouvement(13);						// saut tornade
					moveHero_tornadesideup(sens);
				}
				else if(stormdown){
					mouvement(14); 								// saut tornade
					moveHero_tornadesidedown(sens);
				}
		}
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		private function makedamage(type:int):void {
			switch(type) {
				case 1:
				if (anim_strike1.currentFrame == 5)	aT = true;
				break;
				case 2:
				if (anim_strike2.currentFrame == 5)aT = true;
				break;
				case 3:
				if (anim_strike3.currentFrame == 5)	aT = true;
				break;
				case 4:
				if (anim_ball.currentFrame == 4) aT = true;
				break;
				case 5:
				if (anim_special.currentFrame == 10) {
					var sf:Special_fire = new Special_fire( x - (di+20) *scaleX, y - 25, -scaleX);
					tabFire.push(sf);
					sf.init(tabFire, blocstock,objStock);
					//Carte.effectLayer.addChild(sf.bitmap);
					parent.addChild(sf);
				}	
				break;
			}
		}
		//-------------------------------------------------------------------------------------------------------------------------------------------------------------
			private function moveHero(dx:int):void{
				if (!die) x += speed * dx; 					// déplace le perso sur X
				var C:int = (x + di * dx) / T;						// côté (grille) du perso concerné par la colission
				Cl=checkLateral(C)
				var Co:int =  Cl[0] / T;
				var Ls:int = (y + T - 1) / T;
				if (checkSlopes( blocstock[Ls][Co], blocstock[Ls][Co], Ls, Co)) 	 	return	;
				y += gravite; 							// déplace le perso sur Y
				if (checkFall( Cl[1], di)) return ;
				if (checkRoof((y-hi)/T,Cl[0],di)) return;
				// gravite
				if (gravite++>T) gravite=T							// limite la gravité max à la taille d'une tuile
			}
			//-------------------------------------------------------------------------------------------------------------------------------------------------------------
		private function moveHero_strikefalling(dx:int):void{
				var X:Number = x; var L:int; var di:int = di; var C:int = (X + di * dx) / T;
				Cl = checkLateral(C); X = Cl[0]; L = Cl[1];
				y += 2 * gravite; 							// déplace le perso
				var t:Bloc;
				// tombe
				for (C = (X - di) / T; C < (X + di) / T; C++) {					// vérifies toutes colonnes (grille) sur lesquelles se tient le perso
					if (blocstock[L][C].fr) {
					if (blocstock[L][C].item) {
						if (this.life+blocstock[L][C].life < 100) this.life = this.life+blocstock[L][C].life;
						else this.life = 100;
						if (this.power+blocstock[L][C].power < 75) this.power = this.power + blocstock[L][C].power;
						else this.power = 75;
						this.score = this.score+blocstock[L][C].score;
						//t.unleash();
						removeBox(L, C);
						blocstock[L][C]=[];
					}
					
					else if(blocstock[L][C].destruct){
						blocstock[L][C].resist = blocstock[L][C].resist - force[1];
						if (blocstock[L][C].resist <= 0) {
							if (this.life+blocstock[L][C].life < 100) this.life = this.life+blocstock[L][C].life;
							else this.life = 100;
							if (this.power+blocstock[L][C].power < 75) this.power = this.power +blocstock[L][C].power;
							else this.power = 75;
							this.score = this.score+blocstock[L][C].score;
							//t.unleash();
							removeBox(L, C);
							blocstock[L][C] = [];
						}
						else {
							aT = false;
						}
						
					}
					
					else if ((blocstock[L][C].solide||blocstock[L][C].cloud) && y>=(L-1)* T) {	
						stike_rock.gotoAndPlay(2);		// blocs solides
						y = (L-1)* T;							// position du perso sur Y
						gravite = -8-int(blocstock[L][C].jumper)*blocstock[L][C].upPulse;
						strikefalling = aT = false;
						return				
					}
					}
				}
				// gravite
				if (gravite++>2* T) gravite=2* T							// limite la gravité max à la taille d'une tuile	
			}
			
			//--------------------------------------------------------------------------------------------
			private function moveHero_tornadesidedown(dx:int):void{	
				x += 7.5*dx; 								// déplace le perso sur X
				
				var Y:Number = y; var X:Number = x; var L:int; var di:int = di;var C:int = (X + di * dx) / T;
				Cl=checkLateral(C)
				X = Cl[0];
				L = Cl[1];
				
				Y = y += 1.5*gravite; 							// déplace le perso sur Y
				var t:Bloc;
				// tombe
				for (C=(X-di)/T; C<(X+di)/T; C++) {					// vérifies toutes colonnes (grille) sur lesquelles se tient le perso	
					if (blocstock[L][C].fr) {
						if (blocstock[L][C].item) {
							if (this.life+blocstock[L][C].life < 100) this.life = this.life+blocstock[L][C].life;
							else this.life = 100;
							if (this.power+blocstock[L][C].power < 75) this.power = this.power + blocstock[L][C].power;
							else this.power = 75;
							this.score = this.score+blocstock[L][C].score;
							//t.unleash();
							removeBox(L, C);
							blocstock[L][C]=[];
						}
						else if(blocstock[L][C].destruct){
								if (aT) {
									blocstock[L][C].resist = blocstock[L][C].resist - force[0]- force[1];
									if (blocstock[L][C].resist <= 0) {
										if (this.life+blocstock[L][C].life < 100) this.life = this.life+blocstock[L][C].life;
										else this.life = 100;
										if (this.power+blocstock[L][C].power < 75) this.power = this.power + blocstock[L][C].power;
										else this.power = 75;
										this.score = this.score+blocstock[L][C].score;
										//t.unleash();
										removeBox(L, C);
										blocstock[L][C]=[];
									}
									else {
										aT = false;
									}
								}
							}
						
						else if ((blocstock[L][C].solide||blocstock[L][C].cloud) && y>=(L-1)* T) {			// blocs solides
							y = (L-1)* T;							// position du perso sur Y
							gravite=-1;
							 tornadedown = aT = gauche=droite=false;
							tornadedownTime.reset();
							return				
						}
					}
				}
				// gravite
				if (gravite++>1.5* T) gravite=1.5* T							// limite la gravité max à la taille d'une tuile
			}
			
			//--------------------------------------------------------------------------------------------
			private function moveHero_tornadesideup(dx:int):void{
				
				x += 8*dx; 								// déplace le perso sur X
				
				var Y:Number = y;var X:Number = x;var L:int;var di:int = di;var hi:int = hi;var C:int = (X+di*dx)/T;var i:int;
				
				Cl=checkLateral(C)
				X = Cl[0];L = Cl[1];

				if(jumptor) Y = y += 7*gravite; 							// déplace le perso sur Y
				else Y = y += 11*gravite; 							// déplace le perso sur Y
				var t:Bloc;
				// touche plafond
				if (gravite<0) {									// si le perso saute
					L = (Y-hi)/T;									// case occupée par le haut du perso
					for (i = (X - di) / T; i < (X + di) / T; i++) {				// cases occupées par les limites X du perso
						if (blocstock[L][i].fr) {
							if (blocstock[L][i].item) {
								if (this.life+blocstock[L][i].life < 100) this.life = this.life+blocstock[L][i].life;
								else this.life = 100;
								if (this.power+blocstock[L][i].power < 75) this.power = this.power + blocstock[L][i].power;
								else this.power = 75;
								this.score = this.score+blocstock[L][i].score;
								//t.unleash();
								removeBox(L, i);
								blocstock[L][i]=[];
							}
							
							else if (blocstock[L][i].destruct) {
								if (aT) {
									blocstock[L][i].resist = blocstock[L][i].resist - force[0] - force[1];
									if (blocstock[L][i].resist <= 0) {
										if (this.life+blocstock[L][i].life < 100) this.life = this.life+blocstock[L][i].life;
										else this.life = 100;
										if (this.power+blocstock[L][i].power < 75) this.power = this.power + blocstock[L][i].power;
										else this.power = 75;
										this.score = this.score+blocstock[L][i].score;
										//t.unleash();
										removeBox(L, i);
										blocstock[L][i]=[];
									}
									else {
										aT = false;
									}
								}
							}
							else if (blocstock[L][i].solide) {							// si la case n'est pas vide
								y = (L + 2) * T - hi;					// position du perso sur Y
								gravite=1;
								tornadeup=jumptor =aT = false;	
								jumptorTime.reset();tornadeupTime.reset();
							}
						}
					}
				}
			}	
		
	}
	
}
