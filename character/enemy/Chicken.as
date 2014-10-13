package character.enemy {
	
	import flash.display.MovieClip;
	import character.GlobalEnemy;
	import item.Egg;
	
	
	public class Chicken extends GlobalEnemy {
		
		private var gift_life:int = 30;
		
		private var eat:Boolean;
		private var walk:Boolean;
		private var fly:Boolean;
		private var d:Number;
		private var dy:Number;
		private var detected:Boolean;
		private var egg:int=0;
		public function Chicken(os:Array) {
			blocstock = os;
			// constructor code
			gravite = 1;					
			hostile = true;
			jumpPuls = 14;
			di =18;
			hi = 0;
			life = 1;			
			speed = 4;	
		}
		override public function motricite():void {
			lk = target.x - this.x;	d = Math.abs( lk);dy = Math.abs(target.y - this.y);
			sens = (int(right) - int(left)) * int(!die);
			speed = 3 +int(fly);
			aucune = !right && !left && !fly && !eat && !die;
			walk = (right || left) && !eat && !die && !fly;
			die = (life <= 0);
			score = 150-20*egg;
			if (fly) y++;
			//burning.stickB(x, y);
			if (!die) {
				IA();
				checkTargetCollision();
				CheckProj();
				hurt();
			}
			else {
				pulse = false;
				gravite = 1;
				mouvement(5);
				killmyself();
			}
			if (sens) scaleX = -sens;						// oriente le perso
			if (aucune) mouvement(1);
			if (eat&&!die&&!detected) mouvement (2);
			if (walk) mouvement (3);
			if (fly&&!die) mouvement (4);
			if (!died) moveEnemy();
		}
		private function makeEgg():void {
			var ra:Number = Math.random();
			if (egg <5&&ra<.02) {
				egg++;
				var e:Egg = new Egg(target, blocstock);
				e.x = x; e.y = y-5;
				parent.addChild(e);				
			}
		}
		private function IA():void {
			if (IAtype == 1) {
				if (d < 350&&dy<70) detected = true; else  eat = true;
				
				if (detected) {
					if (d < 350 &&d>200) {
					pulse=fly=eat= false;
					scaleX = int(lk <= 0)-int(lk > 0);
					}
					else if (d <= 200&&d>80&&detected) {
						pulse = fly = eat = false;	left = (lk > 0); right = (lk < 0);
						makeEgg();
						
					}
					else if (d <= 80&&detected) 	{
						if (dy < 150) fly = pulse = true;
						makeEgg();
						eat = false;
						left = (lk > 0);right = (lk < 0);
					}
				}
			}
			
		}
		
		private function checkTargetCollision():void {
			if (d <= 40 && dy  < 40) {
				if((target.sens==1&&lk<40)||(target.sens==-1&&-lk<40)||target.sens==0){
					if (target.aT && !imunTime.running) {
						if(target.powerattack) burning.gotoAndPlay(2);
						imunTime.start();
						this.life = this.life - target.force[0] - target.force[1];
						if (this.life <= 0) { 
							if (target.life + gift_life < 100) target.life = target.life + gift_life;
							else target.life = 100;
							target.score = target.score+this.score;
						}
					}
				}
			}
		}		
	}
	
}
