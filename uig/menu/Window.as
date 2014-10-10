package uig.menu {
		import flash.display.Sprite;
		import flash.events.MouseEvent;
		import uig.menu.MainMenu;
		import uig.titles.MainTitle;
		//---------------------------------------------
		
	
	public class Window extends Sprite {
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
