package character.enemy {
	
	//import Character.Effect.Goat.Charge_aura;
	//import Character.Effect.Goat.Charge_particule;
	import character.GlobalEnemy;
	import flash.utils.Timer;
	
	public class Goat extends GlobalEnemy {
		
		private var charge:Boolean;
		private var eat:Boolean;
		private var Cooldown:Timer = new Timer(2500, 1);
		private var walk:Boolean;
		/*private var Cpar:Charge_particule;
		private var Cparstock:Array = [];
		private var Caur:Charge_aura;
		private var Caurstock:Array = [];*/
		private var d:Number;
		private var dy:Number;
		
		public function Goat(os:Array) {
			blocstock = os;
			// constructor code
			gravite = 1;					// la gravité du jeu
			speed = 3;					// la vitesse du héro
			sens = 0;
			di =20;
			hi = 0;
			hostile = true;
			score = 15;
			force = [2, 0];
			jumpPuls = 0;
			life = 2;
		}
		override public function motricite():void {
			lk = target.x - this.x;	d = Math.abs( lk);dy = Math.abs(target.y - this.y);
			sens = (int(right) - int(left)) * int(!die); speed = 2.5 + 1.5 * int(charge);
			
			aucune = !right && !left && !charge && !eat && !die;
			walk = (right || left) && !eat && !die;
			die = (life <= 0);
			//burning.stickB(x, y);
			if (!die) {
				IA();
				checkTargetCollision();
				CheckProj();
				hurt();
			}
			else {
				mouvement(4);
				killmyself();
			}
			if (sens) scaleX = -sens;						// oriente le perso
			if (aucune) mouvement(1);
			if (eat&&!die) mouvement (2);
			if (walk) mouvement (3);
			if (!died) moveEnemy();
		 	/*
			if (charge&&!die) {
					Cpar = new Charge_particule(di+10,32);Cparstock.push(Cpar);	addChild(Cpar);
					while(Cparstock.length>8){
						Cpar = Cparstock.shift();removeChild(Cpar);	Cpar.kill();Cpar = null;
					}
					Caur = new Charge_aura(-di+5,-4);Caurstock.push(Caur);	addChild(Caur);
					while(Caurstock.length>8){
						Caur = Caurstock.shift();removeChild(Caur);	Caur.kill();Caur = null;
					}
				}
			else {
				while(Cparstock.length>0){
					Cpar = Cparstock.shift();removeChild(Cpar);	Cpar.kill();Cpar = null;
				}
				while(Caurstock.length>0){
					Caur = Caurstock.shift();removeChild(Caur);	Caur.kill();Caur = null;
				}
			}
			*/
		}
		
		private function checkTargetCollision():void {
				if (d <= 40 && dy  < 70) {
					if((target.sens==1&&lk<40)||(target.sens==-1&&-lk<40)||target.sens==0){
						if (target.aT && !imunTime.running) {
							if(target.powerattack) burning.gotoAndPlay(2);
							imunTime.start();
							this.life = this.life - target.force[0] - target.force[1];
							if (!target.powerattack && this.life <= 0) { 
								if(target.power+10<75)target.power=target.power+10;
								else target.power = 75;
							}
							if(life<=0)	target.score = target.score+this.score;
						}
					}
					if (!Cooldown.running&&dy<10&&d <= 40) {
					if (aT&&!target.imunity) target.imunTime.start();	
					target.life = target.life-int(this.aT&&!target.imunity) * this.force[0];
					aT = false;
					Cooldown.start();
					}
				}
			
		}
		
		private function IA():void {
			if(IAtype==1){
				if (d < 220 && dy < 150) {
					eat=charge = false;	right = (lk > 0);left = (lk < 0);
				}
				else {
					charge = right = left = false;
					var a = InPos[0] - this.x;
					if (Math.abs(a) >= 80) {
						eat = false; right = a > 0; left = a < 0;
					}
					else {
						left = right = false;eat = true;
					}
				}
				if (d <= 180 && d > 50 && dy < 150) 	{
					if (!Cooldown.running) charge = true; else charge = false;
				}
				else if (d <= 50 && dy > 63&& dy < 150)	{
					aT = charge = left = right =eat= false;
					scaleX = int(lk <= 0)-int(lk > 0);
				}
				else if (d <= 50 && dy < 63)	{
					charge = true;
					if (Cooldown.running)	{
						charge = aT = left = right =eat= false;	
					}
					else {
						aT = charge = true;
					}
					scaleX = int(lk <= 0)-int(lk > 0);
				}
			}
		}
	}
	
}
