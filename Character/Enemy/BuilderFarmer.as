package  character.enemy{
	
	import character.GlobalEnemy;
	import engine.Carte;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import solid.decor.Bloc;
	
	
	public class BuilderFarmer extends GlobalEnemy {
		
		
		public function BuilderFarmer(os:Array) {
			blocstock = os;
			gravite = 1;sens = 0;di =18;hostile = true;hi = 32;jumpPuls = 12;life = 3;force = [2, 0];score = 20;
			BuildTime.addEventListener(TimerEvent.TIMER_COMPLETE, putCase);
			hitTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishHit);
			// constructor code
		}
		/*override public function init():void {
			objLayer = Carte.objLayer;
			tabFire = Carte.tabFire;
		}*/
		private var walk:Boolean;
		private var run:Boolean;
		private var s_hit:Boolean;
		private var hitting:Boolean;
		
		private var d:Number;
		private var dy:Number;
			
		private var build:Boolean;
		private var ra:Number;
		//private var objLayer:Sprite;
		private var vwalk:Boolean;
		private var walkTime:Timer = new Timer(800, 1);
		private var hitTime:Timer = new Timer(465, 1);
		private var Cooldown:Timer = new Timer(1000, 1);
		private var BuildTime:Timer = new Timer(1600, 1);
		private var finishTime:Timer = new Timer(200,10);
		
		override public function motricite():void {
			
			d = Math.abs( target.x - this.x);dy = Math.abs(target.y - this.y);lk = target.x - this.x;
			sens = (int(right) - int(left)) * int(!die); speed = 1.5 + 1.5 * int(run) + 1 * int(life < 3);
			
			aucune = !right && !left && !s_hit && !run && !die && !walk&&!build;
			walk = (right || left) && !s_hit && !die && !run && (gravite == 0)&&!build;
			vwalk = (right || left) && !s_hit && !die && run && (gravite == 0)&&!build;
			hitting = s_hit && !die;
			die = (life <= 0);
			//burning.stickB(x, y);
			if (!die) {			
				IA();
				checkTargetCollision();
				CheckProj();
				hurt();
			}
			else {
				pulse = false;
				scaleX = int(target.x - this.x <= 0)-int(target.x - this.x > 0);
				mouvement(5);
				BuildTime.removeEventListener(TimerEvent.TIMER_COMPLETE, putCase);
				hitTime.removeEventListener(TimerEvent.TIMER_COMPLETE, finishHit);
				killmyself();
			}
			if (sens) scaleX = -sens;						// oriente le perso
			if (aucune) mouvement(1);
			if (walk) mouvement(2);
			if (vwalk) mouvement(3);
			if (hitting) { mouvement(4); makedamage(1); }
			if (build&&!die) mouvement(6);
			
			if (!died) moveEnemy();
			
		}
		private function makedamage(type:int):void {
			if (anim_strike1.currentFrame == 9)	aT = true;
				
		}
		private function checkTargetCollision():void {
			var a:Boolean = target.sens == 1 && target.x - this.x < 60;var b:Boolean = target.sens == -1 && this.x - target.x < 60;
			if (d <= 70 && dy  < 70) {
					if((a)||(b)||target.sens==0){
						if (target.aT && !imunTime.running) {
							if (target.powerattack) burning.gotoAndPlay(2);;
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
			if (IAtype == 1) {
				if(life>2){
					if (d < 250 && d > 70 && dy < 150) {
						s_hit = run = false;right = (lk > 0);left = (lk < 0);
					}
					else {
					run = s_hit = false;
						if (!walkTime.running) {
							walkTime.start();
							ra = Math.random();
							if (ra <= 0.37) { left = true; right =run  = false; }
							else if (ra > 0.37 && ra <= 0.75) { right = true; left =run  = false;}
							else if (ra > 0.75 && ra <= 1) left = right =run = false;
						}
					}
					if (d <= 250 && d > 70&&dy<150) 	run = true;
					else if (d <= 70 && dy < 50)	{
						if (hitTime.running) s_hit = true;
						else {
							if (!Cooldown.running)hitTime.start();
							else s_hit = aT = false;
						}
						run = left = right = false;	scaleX = int(lk <= 0)-int(lk > 0);
					}
				}
				else {
					if (d < 160 && !BuildTime.running) { 	
						s_hit = build = false;run = true;left = (lk > 40);right = (lk < -40);
						if (lk <= 40&&lk >=-40) {
							pulse = true;left = ( target.sens == 1 ||target.sens == 0);right = (target.sens == -1);
						}
						else pulse = false;
					}
					else {
					run = left = right = false;scaleX = int(lk <= 0)-int(lk > 0);
					construct();
					}
				}
			}
		}
		
		private function construct():void {
		var C:int = (x + di * -scaleX) / T - scaleX; var L:int = (y / T);
			if (!blocstock[L][C].fr) {
				if(!BuildTime.running){
					BuildTime.start();build = true;	return;
				}
			}
			else build = false;	
		}
		private function finishHit(event:TimerEvent):void
		{	Cooldown.start();aT = false;
		}
		private function putCase(event:TimerEvent):void
		{	var C:int = (x + di * -scaleX) / T - scaleX;var L:int = (y / T);
			if(!blocstock[L][C].fr){
			var b = new Bloc();			// position s
			b.solide = b.destruct = true;	
			b.resist = 1;b.score = 2;b.fr = 9;
			blocstock[L][C] =b;
			addBox(L, C,9);
			//objLayer.addChild(blocstock[L][C]);
			}
		}
	}
	
}
