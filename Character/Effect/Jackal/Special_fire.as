package Character.Effect.Jackal {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Engine.Carte;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class Special_fire extends Sprite {
		public var speed:Number;
		public var sens:int;
		public var force:int;
		private var _X:Number; 
		private var _Y:Number;
		private var bitmapData:BitmapData;
		public var bitmap:Bitmap;
		private var origin:Point;
		private var blur:BlurFilter;
		private var colorTransform1:ColorTransform;
		public var display:Sprite;
		private var T:int;
		private var objstock:Array;
		private var	tabFire:Array;
		private var effectLayer:Sprite;
		private var objLayer:Sprite;
		public function Special_fire(X:Number, Y:Number, way:int,ob:Array) {
			x = X;
			y = Y;
			T = Carte.T;
			tabFire = Carte.tabFire;
			objstock = ob;
			// constructor code
			sens = way;
			force = 8;
			if(way==1)rotationY = 180;
			speed = 10;
			effectLayer = Carte.effectLayer;
			objLayer = Carte.objLayer;
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
		private function updateDraw(e:Event):void{
			this.bitmapData.applyFilter(bitmapData,bitmapData.rect,origin,blur);
			this.bitmapData.colorTransform(bitmapData.rect, colorTransform1);
			this.bitmapData.draw(display);
		}
 
		private function update(e:Event):void{
			this.x += speed * sens;
			if (width < 70) { height = height * 1.1; width = width * 1.1;}
			if (force <= 0) kill();
			checkWall();
		}
		private function checkWall():void {
			var dx:int = this.sens;										// ligne (grille) du point bas du perso
			var C:int=int((x+sens*width/4)/T);
			var L:int;
			// latéral	
			for (L=this.y/T; L<(this.y+height)/T; L++) {					// vérifies toutes lignes (grille) sur lesquelles se tient le perso
				if (objstock[L][C].solide) {								// si le bord renconte un bloc solide en latéral (prévoir multiples tuiles)
					// colle le perso au bord du bloc
					if(objstock[L][C].destruct){
						var a = force-objstock[L][C].resist;
						objstock[L][C].resist = objstock[L][C].resist - force;
						force = a;
						if (objstock[L][C].resist <= 0) {
							objLayer.removeChild(objstock[L][C]);
							objstock[L][C]=[];
						}
					}
					else {
						kill();
					}
				}
			}
		}
		
		public function kill():void {
			removeEventListener(Event.ENTER_FRAME, update);
			//bitmap.removeEventListener(Event.ENTER_FRAME, updateDraw);
			//if(this.bitmap.stage)Carte.effectLayer.removeChild(this.bitmap);
			if(stage)effectLayer.removeChild(this);
			tabFire.splice(this);
		}
	}
	
}
