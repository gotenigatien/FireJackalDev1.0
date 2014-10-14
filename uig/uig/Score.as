package uig.uig {
	import character.CharObj;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	public class Score extends Sprite {
		public var sc:int;
		private var _txt:TextField;
		private var _txtsc:TextField;
		
		private var pl:CharObj;
		//private var font:SFSlapstickComicShaded = new SFSlapstickComicShaded();
		public function Score($pl:CharObj,s:int) {
			// constructor code
			sc = s;
			pl = $pl;
			
			[Embed(source='../../Ressources/Font/SFSlapstickComicShaded.ttf'
			,fontFamily  ='SFSlapstickComicShaded'
			,fontName  ='SFSlapstickComicShaded'
			,mimeType = "application/x-font"
			,fontStyle   ='normal' // normal|italic
			,fontWeight  ='normal' // normal|bold
			,unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E'
			,embedAsCFF='false'
			)]
			var SlapstickComic:Class;
			
		
			Font.registerFont(SlapstickComic);
			
		
		var _formatTxt:TextFormat = new TextFormat("SFSlapstickComicShaded",20);
			//_formatTxt.font = sf.fontName;
			_formatTxt.size = 20;_formatTxt.color = 0x990000;
			
			_txt = new TextField(); _txt.defaultTextFormat = _formatTxt;
			_txt.setTextFormat(_formatTxt);
			_txt.text = "SCORE :";
			_txt.embedFonts = true;
			_txt.selectable = false;
			_txtsc = new TextField();
			_txtsc.defaultTextFormat = _formatTxt;
			_txtsc.setTextFormat(_formatTxt);_txtsc.text = s.toString();
			_txtsc.embedFonts = true;
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
