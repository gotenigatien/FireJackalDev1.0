package  character.enemy{
	
	import character.GlobalEnemy;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class NormalFarmer extends GlobalEnemy {
		
		
		public function NormalFarmer(os:Array) {
			blocstock = os;
			gravite = 1;					// la gravité du jeu
			speed = 1;					// la vitesse du héro
			sens = 0;
			di =18;
			hostile = true;
			hi = 32;
			jumpPuls = 0;
			life = 3;
			score = 15;
			hitTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishHit);
			// constructor code
		}
		
		private var walk:Boolean;
		private var run:Boolean;
		private var s_hit:Boolean;
		private var hitting:Boolean;
		private var ra:Number = 0.7;
		
		private var vwalk:Boolean;
		private var walkTime:Timer = new Timer(800, 1);
		private var hitTime:Timer = new Timer(465, 1);
		private var Cooldown:Timer = new Timer(1200, 1);
		
		private var d:Number;
		private var dy:Number;

		override public function motricite():void {
			lk = target.x - this.x;	d = Math.abs( lk);dy = Math.abs(target.y - this.y);
			sens = (int(right) - int(left)) * int(!die); speed = 1 + 1.5 * int(run);
			
			aucune = !s_hit && !run && !die && !walk;
			walk = (right || left) && !die && !run && (gravite == 0);
			vwalk = (right || left) && !die && run && (gravite == 0);
			hitting = s_hit && !die;
			die = (life <= 0);
			//burning.stickB(x, y);
			if (!die) {
				IA();
				checkTargetCollision();
				CheckProj();
				hurt();
			}
			else {mouvement(5);
				hitTime.removeEventListener(TimerEvent.TIMER_COMPLETE, finishHit);
				killmyself();
			}
			if (sens) scaleX = -sens;						// oriente le perso
			if (aucune) mouvement(1);
			if (walk) mouvement(2);
			if (vwalk) mouvement(3);
			if (hitting && ra > 0.5) {
				mouvement(4);
				force = [2, 0];
				makedamage(1);
			}
			if (hitting && ra < 0.5) {
				mouvement(6);
				force = [4, 0];
				makedamage(2);
			}
			if (!died) moveEnemy();
		}
		private function makedamage(type:int):void {
			switch(type) {
				case 1:
				if (anim_strike1.currentFrame == 9) aT = true;
				break;
				case 2:
				if (anim_strike2.currentFrame == 5) aT = true;
				break;
			}
		}
		private function checkTargetCollision():void {
			var a:Boolean = target.sens == 1 && lk < 60; var b:Boolean = target.sens == -1 && lk < 60;
			if (d <= 70 && dy  < 70) {
					if((a)||(b)||target.sens==0){
						if (target.aT && !imunTime.running) {
							if(target.powerattack) burning.gotoAndPlay(2);
							imunTime.start();
							this.life = this.life - target.force[0] - target.force[1];
							if (!target.powerattack && this.life <= 0) { 
								if(target.power+5<75)target.power=target.power+5;
								else target.power = 75;
							}
							if(life<=0)	target.score = target.score+this.score;
						}
					}
					if(dy<40){
						if(aT&&!target.imunity)target.imunTime.start();	
						target.life = target.life-int(this.aT&&!target.imunity) * this.force[0];
						aT = false;
					}
				}
			
		}
		private function IA():void {
			if(IAtype==1){
				if (d < 300 && d > 70&&dy<150) {
					s_hit = false;right = (lk > 0);	left = (lk < 0);
				}
				else {
					run = s_hit = false;
					if (!walkTime.running) {
						walkTime.start();
						ra = Math.random();
						if (ra <= 0.25) { left = true; right = false; }
						else if (ra > 0.25 && ra <= 0.5) { right = true; left = false; }
						else if (ra > 0.5 && ra <= 1) left = right = false;
					}
				}
				if (d < 300 && d > 200)			run = false;
				else if (d <= 200 && d > 70&&dy<150) 	run = true;
				else if (d <= 70 && dy < 50)	{
					if (hitTime.running) s_hit = true;
					else {
						if (!Cooldown.running)	hitTime.start();
						else s_hit = aT = false;
					}
					run = left = right = false;	scaleX = int(lk <= 0)-int(lk > 0);
				}
			}
		}
		
		private function finishHit(event:TimerEvent):void
		{	Cooldown.start();ra = Math.random();aT = false;
		}
	}
	
}
