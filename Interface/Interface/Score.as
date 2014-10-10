package Interface.Interface {
	import Character.CharObj;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Score extends Sprite {
		public var sc:int;
		private var _txt:TextField;
		private var _txtsc:TextField;
		private var _formatTxt:TextFormat = new TextFormat();
		private var comic:SFSlapstickComicShaded = new SFSlapstickComicShaded();
		private var pl:CharObj;
		public function Score($pl:CharObj,s:int) {
			// constructor code
			sc = s;
			pl = $pl;
			//_formatTxt.font = "SF Slapstick Comic Shaded";
			_formatTxt.font = comic.fontName;_formatTxt.size = 20;_formatTxt.color = 0x990000;
			
			_txt = new TextField(); _txt.defaultTextFormat = _formatTxt; _txt.text = "SCORE :";
			_txt.selectable = false;
			_txtsc = new TextField();
			_txtsc.defaultTextFormat = _formatTxt;_txtsc.text = s.toString();
			_txtsc.x = _txt.width;_txtsc.selectable = false;
			this.addChild(_txt);this.addChild(_txtsc);
			addEventListener(Event.ENTER_FRAME, run);
		}
		
		public function run(e:Event) {
			if (!pl.die) this.updateScore(pl.score);
		}
		
		public function updateScore(ns:int):void {
		 if (ns > sc) sc++; _txtsc.text = sc.toString(); 
		}
		
	}
	
}
