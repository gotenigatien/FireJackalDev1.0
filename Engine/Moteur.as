package engine {
	public class Moteur {
		import character.CharObj;
		import character.GlobalEnemy;
		import character.playable.Jackal;
		import flash.display.Sprite;
		import flash.events.Event;
		
		private var enemyStock:Array;
		private var scrolling:Scrolling;
		private var jackal:Jackal;
		private var enemyLayer:Sprite;
		public function Moteur() {
		}
		public function initialise(ja:Jackal, es:Array, scro:Scrolling) {
			scrolling = scro;
			enemyStock = es;
			jackal = ja;
		}
		public function initLayer(eL:Sprite) {
			enemyLayer = eL;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function run(e:Event) {
			var i:int=0;
			for (i = 0; i < enemyStock.length; i++ ) {
				if(!enemyStock[i].died){
				enemyStock[i].motricite();
				}
				if (enemyStock[i].died&&enemyStock[i].stage) {
					enemyLayer.removeChild(enemyStock[i]);
					enemyStock.slice(i, 1);
				}
			}
			scrolling.run();
			jackal.motricite();
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------------------------------
		
	}
}