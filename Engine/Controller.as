package engine {
	public class Controller {
		import character.playable.Jackal;
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.events.TransformGestureEvent;
		import flash.ui.Multitouch;
		import flash.ui.MultitouchInputMode;
		import flash.utils.Timer;
		
		private var jackal:Jackal;
		private var lpos:Array=new Array(0,0);
		private var clicTime:Timer=new Timer(300,1);
		
		
		public function Controller() {
			
		}
		public function initialise(a:Jackal) {
			jackal = a;
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
		}
		public function run() {
			with(jackal) {			
				stage.addEventListener(MouseEvent.MOUSE_DOWN, reportDown); 
				stage.addEventListener(MouseEvent.MOUSE_UP, reportUp); 
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
				
				jumpTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishJump);
				jumptorTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishJumptor);
				strikingTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishStriking);
				ballingTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishBalling);
				strikefallingTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishStrikefall);
				tornadeupTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishTornadeup);
				tornadedownTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishTornadedown);
				bottomTime.addEventListener(TimerEvent.TIMER_COMPLETE, finishBottomtime);
				special1Time.addEventListener(TimerEvent.TIMER_COMPLETE, finishSpecial1time);
					
			}
		}
		//-----
		// Enable dispatch of gesture
		
		
		private function finishSpecial1time(event:TimerEvent):void
		{	jackal.special1=false;
			jackal.imunity = false;
		}
		private function finishBottomtime(event:TimerEvent):void
		{	jackal.bottom=false;
		}
		private function finishJumptor(event:TimerEvent):void
		{	with (jackal){
			jumptor=false;
			tornadeup=true;
			tornadeupTime.start();
			}
		}
		private function finishTornadeup(event:TimerEvent):void
		{	with(jackal){
			tornadeup=false;
			GestureReaction(1);
			aT = false;
			powerattack = false;
			imunity = false;
			}
		}
		private function finishTornadedown(event:TimerEvent):void
		{	with (jackal)
			{tornadedown=false;
			GestureReaction(1);
			aT = false;
			powerattack = false;
			imunity = false;
			}
		}
		private function finishStriking(event:TimerEvent):void
		{	with (jackal){
				striking = false;
				strikehasard=Math.random();
				aT = false;
			}
			
		}
		private function finishStrikefall(event:TimerEvent):void
		{	with(jackal){
			strikefall=false;
			gravite = 1;
			strikefalling = true;
			aT = true;
			force[1] = 0;
			}
		}
		private function finishBalling(event:TimerEvent):void
		{	jackal.balling=false;
			jackal.aT = false;
		}
		private function finishJump(event:TimerEvent):void
		{	with(jackal){
			GestureReaction(2);
			}
		}
		private function reportDown(event:MouseEvent):void 
		{ 	lpos[0]=event.stageX;
			lpos[1]=event.stageY;
			clicTime.start();
		}
		private function reportUp(event:MouseEvent):void 
		{ 
			calculatetrans(event.stageX,event.stageY);
		}

		private function onSwipe(event:TransformGestureEvent):void
		{
			with (jackal){
				if ( event.offsetX == -1 ) {
					trace("Swipe-gauche");
					if(gauche){
						striking = true;
						strikingTime.start();
					}
						GestureReaction(1);
						gauche =  	true;
				}
				if ( event.offsetX == 1 ){ 
					trace("Swipe-droite");
						if(droite){
						striking=true;
						strikingTime.start();
					}
						GestureReaction(1);
						droite =  	true;
				}
				if ( event.offsetY == -1 ){
					trace("Swipe-haut");
					if(!jumpTime.running){
							haut=true;
							jumpTime.start();
						}
				}
				if ( event.offsetY == 1 ){
					trace("Swipe-bas");
						if(droite||gauche){
						balling=true;
						ballingTime.start();
						}
						if(gravite!=0&&!strikefallingTime.running){
								strikefall=true;
								strikefallingTime.start();
						}
						if(aucune&&!bottomTime.running){
								bottom=true;
								bottomTime.start();
							}
				}
			}
		 
		}
		
		
		private function calculatetrans(upX:Number,upY:Number):void{
			var Tx:Number=upX-lpos[0];
			var Ty:Number=upY-lpos[1];
			//trace("Tx:"+Tx+" | Ty:"+Ty);
			with(jackal){
				if(clicTime.running){
					if(Tx>40&&Ty>40&&Math.abs(Tx/Ty)<1.7){
						trace("Mouse/Right-Down");
						if (!tornadedownTime.running && gravite != 0 && power >= 5) {
							power = power -5;
							GestureReaction(2);
							gravite = 1;
							force = [2, 2] 	;	
							powerattack = true;
							aT = true;
							imunity = true;
							if(!gauche&&!droite){droite=true};
							if(gauche){gauche=false;droite=true;}
							tornadedown=true;
							tornadedownTime.start();
						}			
						
						return;
					}
					if(Tx<-40&&Ty>40&&Math.abs(Tx/Ty)<1.7){
						trace("Mouse/Left-Down");
						if (!tornadedownTime.running && gravite != 0 && power >= 5) {
							power = power -5;
							GestureReaction(2);
							gravite = 1;
							force = [2, 2] 	;	
							powerattack = true;
							aT = true;
							imunity = true;
							if(!gauche&&!droite){gauche=true};
							if(droite){droite=false;gauche=true;}
							tornadedown=true;
							tornadedownTime.start();
						}			
						
						return;
					}
					if(Tx>40&&Ty<-40&&Math.abs(Tx/Ty)<1.7){
						trace("Mouse/Right-Up");
						if (!jumptorTime.running && !tornadeup && power >= 5) {
							power = power -5;
							GestureReaction(2);
							gravite = -1;
							force = [2, 2] 	;	
							powerattack = true;
							aT = true;
							imunity = true;
							if(!gauche&&!droite){droite=true};
							if(gauche){gauche=false;droite=true;}
							jumptor=true;
							jumptorTime.start();
						}			
						
						return;
					}
					if(Tx<-40&&Ty<-40&&Math.abs(Tx/Ty)<1.7){
						trace("Mouse/Left-Up");
						if (!jumptorTime.running && !tornadeup && power >= 5) {
							power = power -5;
							GestureReaction(2);
							gravite = -1;
							force = [2, 2] 	;	
							powerattack = true;
							aT = true;
							imunity = true;
							if(!gauche&&!droite){gauche=true};
							if(droite){droite=false;gauche=true;}
							jumptor=true;
							jumptorTime.start();
						}			
						
						return;
					}
					if(Tx>10&&Ty<45&&Ty>-45&&Math.abs(Tx/Ty)>2){
						trace("Mouse/Droite");
						if(droite){
						striking=true;
						strikingTime.start();
						}
						GestureReaction(1);
						droite =  	true;
						
						return;
					}
					if(Tx<-10&&Ty<45&&Ty>-45&&Math.abs(Tx/Ty)>2){
						trace("Mouse/Gauche");
						if(gauche){
						striking=true;
						strikingTime.start();
						}
						GestureReaction(1);
						gauche =  	true;
						
						return;
					}
					if(Tx<7&&Tx>-7&&Ty>12&&Math.abs(Ty/Tx)>2){
						trace("Mouse/Bas");
						if(droite||gauche){
						balling=true;
						ballingTime.start();
						}
						if(gravite!=0&&!strikefallingTime.running){
								strikefall=true;
								strikefallingTime.start();
							}
						if(aucune&&!bottomTime.running){
								bottom = true;
								bottomTime.start();
							}
						
						return;
					}
					if(Tx<45&&Tx>-45&&Ty<-12&&Math.abs(Ty/Tx)>2){
						if(!jumpTime.running){
							haut=true;
							jumpTime.start();
						}
						return;
					}
					if (Tx > -10 && Tx < 10 && Ty < 10 && Ty > -10) {
						trace("STOP")
						if(!striking&&!balling){
							GestureReaction(0);
						}
						return;
					}
				}
				else{
					if(Tx>-10&&Tx<10&&Ty<10&&Ty>-10){
					trace("LONGTAP");
					if ( !special1Time.running && power >= 25) {
							power = power - 25;
							GestureReaction(1);
							special1 = true;
							imunity = true;
							special1Time.start();
					}
					return;
					}
				
				}
		}
		
	}
		
	}
	
}