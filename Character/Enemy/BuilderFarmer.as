﻿package  Character.Enemy{
	
	import Character.CharObj;
	import Character.GlobalEnemy;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Engine.Carte;
	import Solid.Decor.Tuiles;
	
	
	public class BuilderFarmer extends GlobalEnemy {
		
		
		public function BuilderFarmer(ob:Array) {
			objstock = ob;
			gravite = 1;					// la gravité du jeu
			speed = 1;					// la vitesse du héro
			sens = 0;
			di =18;
			hostile = true;
			hi = 32;
			jumpPuls = 12;
			life = 3;
			force = [2, 0];
			score = 20;
			BuildTime.addEventListener(TimerEvent.TIMER_COMPLETE, putCase);
			hitTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishHit);
			// constructor code
		}
		private var walk:Boolean;
		private var run:Boolean;
		private var s_hit:Boolean;
		private var hitting:Boolean;
		
		private var d:Number;
		private var dy:Number;
			
		private var build:Boolean;
		private var ra;
	
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
						s_hit = false;
						if (!walkTime.running) {
							walkTime.start();
							if (ra <= 0.25) { left = true; right =run  = false; }
							else if (ra > 0.25 && ra <= 0.5) { right = true; left =run  = false;}
							else if (ra > 0.5 && ra <= 1) left = right =run = false;
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
				var C:int = (x+di*-scaleX) / T-scaleX;var L:int = (y / T);
				if (!objstock[L][C].fr) {
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
			if(!objstock[L][C].fr){
			var t= new Tuiles();	
			t.x = C * T;t.y = L * T;				// position s
			t.gotoAndStop(9);		// frame à afficher
			t.solide = t.destruct = true;	
			t.resist = 1;t.score = 2;t.fr = 9;
			objstock[L][C] = t;
			Carte.objLayer.addChild(objstock[L][C]);
			}
		}
	}
	
}