package Interface.Menu {
		import flash.display.MovieClip;
		import flash.events.MouseEvent;
	
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
