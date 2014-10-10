package uig.menu {
		import flash.display.MovieClip;
	
	public class MainMenu extends MovieClip {
		private var choosemap:ChooseMap = new ChooseMap();	
		
		public function MainMenu() {
			// constructor code
		}
		public function start() {
			goMapChooser();
		}
		
		public function goMapChooser() {
			addChild(choosemap);
			choosemap.start();
		}
	}
	
}
