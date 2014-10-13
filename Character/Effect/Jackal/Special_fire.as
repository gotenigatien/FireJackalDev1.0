package character.effect.jackal {
	
	import engine.Carte;
	import flash.display.Sprite;
	import flash.events.Event;
	import solid.decor.Bloc;
	
	public class Special_fire extends Sprite {
		private var speed:Number;
		public var sens:int;
		public var force:int;
		//private var bitmapData:BitmapData;
		//public var bitmap:Bitmap;
		//private var origin:Point;
		//private var blur:BlurFilter;
		//private var colorTransform1:ColorTransform;
		//public var display:Sprite;
		private var T:int=32;
		private var blocstock:Array;
		private var objstock:Array;
		private var	tabFire:Array;
		public function Special_fire(X:Number, Y:Number, way:int) {
			x = X;y = Y;
			// constructor code
			sens = way;	force = 8;
			if(way==1)rotationY = 180;
			speed = 10;
			//effectLayer = Carte.effectLayer;
			//display = new MovieClip();
			//display.addChild(this);
			//bitmapData = new BitmapData(Carte.map[1].length*T,Carte.map.length*T,true,0x00000000);
			//bitmap = new Bitmap(bitmapData);
			//blur = new BlurFilter(.1,.1);
			//origin = new Point(0,0);	
			//colorTransform1 = new ColorTransform(0.999,0.95,0.9,0.910);
			this.addEventListener(Event.ENTER_FRAME, update);
			//bitmap.addEventListener(Event.ENTER_FRAME, updateDraw);
		}
		/*
		private function updateDraw(e:Event):void{
			this.bitmapData.applyFilter(bitmapData,bitmapData.rect,origin,blur);
			this.bitmapData.colorTransform(bitmapData.rect, colorTransform1);
			this.bitmapData.draw(display);
		}
		*/
		public function init(tb:Array, bs:Array,os:Array) {
			tabFire = tb;
			blocstock = bs;
			objstock = os;
			
		}
		private function update(e:Event):void{
			this.x += speed * sens;
			if (width < 70) { height = height * 1.1; width = width * 1.1;}
			if (force <= 0) kill();
			checkWall();
		}
		private function removeBox(L:int, C:int) {
			C= (C % 26);
			L = (L % 16);
			objstock[L][C].gotoAndStop("vide");
		}
		private function checkWall():void {
			var C:int=int((x+width/4)/T);
			var Cd:int=int((x-sens*width/4)/T);
			var L:int;
			var t:Bloc;
			var i:int;
			var la = this.y / T;
			var lb = (this.y + height) / T;
			// latéral	
			for (L = la; L < lb; L++) {
				for (i = Cd; i <= C;i++ ){
					if (blocstock[L][C].fr) { t = blocstock[L][C];
						if (t.solide) {								
							// colle le perso au bord du bloc
							if(t.destruct){
								var a = force-t.resist;
								t.resist = t.resist - force;
								force = a;
								if (t.resist <= 0) {
									//t.unleash();
									removeBox(L, C);
									blocstock[L][C]=[];
								}
							}
							else kill();
						}
					}
				}
			}
		}
		
		public function kill():void {
			removeEventListener(Event.ENTER_FRAME, update);
			//bitmap.removeEventListener(Event.ENTER_FRAME, updateDraw);
			//if(this.bitmap.stage)Carte.effectLayer.removeChild(this.bitmap);
			if(stage)parent.removeChild(this);
			tabFire.splice(this);
		}
		
	}
	
}
