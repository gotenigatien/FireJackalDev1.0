package solid.decor {
	
	import flash.display.MovieClip;
	
	
	public class Tuiles extends MovieClip {
		
		public function Tuiles() {
			// constructor code
		}
		public function destroy():void {
		}
		public function unleash():void {
			parent.removeChild(this);
		}
		
	}
	
}
