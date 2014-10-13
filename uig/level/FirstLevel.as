package uig.level {
		import character.playable.Jackal;
		import flash.events.Event;
		import flash.net.URLRequest;
		import tools.library.CSV;
		
	public class FirstLevel extends TLevel{
		
		public function FirstLevel() {
			// constructor code
		}
		public function start() {
		load_tablevel("../../Ressources/Levels/1_1.csv");
		
		}
		private function initialise() {
			BitInit();
			player.x=100;player.y=250;
			AddAllLayers();
		}
		
		private function load_tablevel(level:String) : void
		{
			csvlib = new CSV( new URLRequest(level) );
			csvlib.addEventListener( Event.COMPLETE, completeLoadlevel );
		}
		private function load_tabenemy(enemies:String) : void
		{
			csvlib = new CSV( new URLRequest(enemies) );
			csvlib.addEventListener( Event.COMPLETE, completeLoadEnemies );
		}
		
		private function completeLoadlevel ( event : Event )
		{
		csvlib.removeEventListener(Event.COMPLETE, completeLoadlevel);
		tab_level = csvlib.receive();
		load_tabenemy("../../Ressources/Enemies/1_1.csv")
		}
		private function completeLoadEnemies ( event : Event )
		{
		csvlib.removeEventListener(Event.COMPLETE, completeLoadEnemies);
		tab_enemy = csvlib.receive();
		initialise();
		this.addEventListener(Event.ENTER_FRAME, moteur.run);			// pilote
		}
		
		
	}
	
}
