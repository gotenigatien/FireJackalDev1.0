package Interface.Menu {

	import flash.display.MovieClip;
	import Interface.Level.FirstLevel;
	
	public class ChooseMap extends MovieClip {
		private var firstlevel:FirstLevel = new FirstLevel();
		
		public function ChooseMap() {
			// constructor code
		}
		
		public function goMap() {
			firstlevel.start();
		}
		public function start() {
				addChild(firstlevel);
				goMap();
		}
	}
	
}
