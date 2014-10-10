package uig.menu {

	import flash.display.MovieClip;
	import uig.level.FirstLevel;
	
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
