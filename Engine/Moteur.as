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
		
		public function Moteur() {
		}
		public function initialise(ja:Jackal, es:Array, scro:Scrolling,m:Array,g:Sprite) {
			scrolling = scro;
			enemyStock = es;
			jackal = ja;
			scrolling.initialise(ja,m,es,g);
			
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function run(e:Event) {
			var i:int=0;
			for (i = 0; i < enemyStock.length; i++ ) {
				if(!enemyStock[i].died){
				enemyStock[i].motricite();
				}
				if (enemyStock[i].died&&enemyStock[i].stage) {
					Carte.enemyLayer.removeChild(enemyStock[i]);
					enemyStock.slice(i, 1);
				}
			}
			scrolling.run();
			jackal.motricite();
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------------------------------
		
	}
}