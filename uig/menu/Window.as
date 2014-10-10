package uig.menu {
		import flash.events.Event;
		import flash.display.MovieClip;
		import uig.titles.MainTitle;
		import flash.events.MouseEvent;
		//---------------------------------------------
		
	
	public class Window extends MovieClip {
		private var maintitle:MainTitle = new MainTitle();	
		private var mainmenu:MainMenu = new MainMenu();	
		
		public function Window() {
			// constructor code
			addChild (maintitle);
			maintitle.addEventListener(MouseEvent.CLICK, maintitle_button);
			
		}
		
		private function maintitle_button(e:MouseEvent) {
			maintitle.removeEventListener(MouseEvent.CLICK, maintitle_button);
			removeChild(maintitle);
			gomainmenu();
		}
		
		public function gomainmenu() {
			addChild(mainmenu);
			mainmenu.start();
		}
	}
	
}
