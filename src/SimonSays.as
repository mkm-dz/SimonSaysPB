package
{	
	import MyUtilities.*;
	import buttons.*;

	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent
	import flash.text.TextFormat;
	

	
	import qnx.ui.text.Label;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.skins.SkinStates;
	import qnx.display.IowWindow;
	import qnx.dialog.DialogAlign;
	import qnx.dialog.DialogSize;
	import qnx.dialog.AlertDialog;
	
	
	
	
	
	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#FFFFFF")]
	
	public class SimonSays extends Sprite
	{	
	
		private var btn_TopLeft:LabelButton;
		private var btn_TopRight:LabelButton;
		private var btn_BottomLeft:LabelButton;
		private var btn_BottomRight:LabelButton;
		private var level:int;
		private var playing:int;		
		private var moving:int;
		private var numeroAleatorio:int;
		private var queueOne:Queue;
		private var queueTwo:Queue;
		private var myTimer:Timer;
		private var myTimerB:Timer;
		private var interGameTimer:Timer;
		private var firstRound:Boolean;
		private var points:Label;
		private var lblLevel:Label;
		private var pointsInt:int;
		
		
		public var soundChannel:SoundChannel;
		
		[Embed(source="./sounds/A.mp3")]private var soundA:Class;
		var sndA : Sound ;
		[Embed(source="./sounds/B.mp3")]private var soundB:Class;
		var sndB : Sound ;
		[Embed(source="./sounds/C.mp3")]private var soundC:Class;
		var sndC : Sound ;
		[Embed(source="./sounds/D.mp3")]private var soundD:Class;
		var sndD : Sound ;
		[Embed(source="./sounds/error.mp3")]private var soundX:Class;
		var sndX : Sound ;
		
		
		
		public function SimonSays()
		{
			initializeUI();
			initializeSounds();
			level=1;
			moving=0;
			//0 juega la compu, 1 juegas tu, -1 perdiste
			playing=0;
		    queueTwo= new Queue;
			queueOne = new Queue;
			interGameTimer = new Timer(700,1);
			
			
			
			
		}
		

		private function initializeSounds():void{

			sndA = new soundA() as Sound;
			sndB = new soundB() as Sound;
			sndC = new soundC() as Sound;
			sndD = new soundD() as Sound;
			sndX = new soundX() as Sound;
			
		}
		
		
		private function initializeUI():void
		{
			btn_TopLeft = new LabelButton();
			btn_TopRight = new LabelButton();
			btn_BottomLeft = new LabelButton();
			btn_BottomRight = new LabelButton();
			
			var lblFormat:TextFormat = new TextFormat();
			lblFormat.font = "BBAlpha Sans";
			lblFormat.bold = true;
			lblFormat.size = 15;
			lblFormat.color = 0x000000;
		

			
			points = new Label();
			points.format = lblFormat;
			points.htmlText ="Points:0";
			points.wordWrap = true;
			points.multiline = false;
			points.width=300;
			
			lblLevel = new Label();
			lblLevel.format = lblFormat;
			lblLevel.htmlText ="Level:1";
			
			points.x=Constants.BTNDEFACE/2;
			points.y=20;
			lblLevel.x=stage.stageWidth-(Constants.BTNDEFACE*2);
			lblLevel.y=20;
			
			btn_TopLeft.label = "";
			btn_TopLeft.x=Constants.BTNDEFACE/2; btn_TopLeft.y=Constants.BTNDEFACE; btn_TopLeft.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_TopLeft.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_TopRight.label = "";
			btn_TopRight.x=(stage.stageWidth+(Constants.BTNDEFACE/4))/2; btn_TopRight.y=Constants.BTNDEFACE; btn_TopRight.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_TopRight.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_BottomLeft.label = "";
			btn_BottomLeft.x=Constants.BTNDEFACE/2; btn_BottomLeft.y=(stage.stageHeight+Constants.BTNDEFACE)/2; btn_BottomLeft.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_BottomLeft.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_BottomRight.label = "";
			btn_BottomRight.x=(stage.stageWidth+(Constants.BTNDEFACE/4))/2; btn_BottomRight.y=(stage.stageHeight+Constants.BTNDEFACE)/2; btn_BottomRight.width=(stage.stageWidth-Constants.BTNDEFACE)/2; btn_BottomRight.height=(stage.stageHeight-Constants.BTNDEFACE)/2;
			
			btn_TopLeft.setSkin(RedButton);
			btn_TopRight.setSkin(GreenButton);
			btn_BottomLeft.setSkin(YellowButton);
			btn_BottomRight.setSkin(BlueButton);
		
			
			
			
			
			btn_TopLeft.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,0)},false, 0, true);
			btn_TopRight.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,1)},false, 0, true);
			btn_BottomLeft.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,2)},false, 0, true);
			btn_BottomRight.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent){playerMove(evt,3)},false, 0, true);
		
			addChild(btn_TopLeft);	
			addChild(btn_TopRight);	
			addChild(btn_BottomLeft);	
			addChild(btn_BottomRight);	
			addChild(points);
			addChild(lblLevel);
			
			firstRound=true;
			var myDialog:AlertDialog = new AlertDialog();
				myDialog.title = "Instructions";
				myDialog.message = "Learn the moves, then repeat the sequence.";
				myDialog.dialogSize = DialogSize.SIZE_MEDIUM;
				myDialog.addButton("Ok");
				myDialog.addEventListener(Event.SELECT, function(evt:Event){(evt.target as AlertDialog).cancel();
				stage.addEventListener(Event.ENTER_FRAME, playGame);
				
				
				},false, 0, true);
				
				myDialog.align = DialogAlign.TOP;
				myDialog.show(IowWindow.getAirWindow().group);
				
			
			

	
		
	
		}
	

		private function playSound(tipo:int):void{
			try{
				switch(tipo){
					case 0:
					soundChannel = sndA.play();
					break;
					case 1:
					soundChannel = sndB.play();
					break;
					case 2:
					soundChannel = sndC.play();
					break;
					case 3:
					soundChannel = sndD.play();
					break;
					case -1:
					soundChannel = sndX.play();
					break;
				}
			}catch(ex:Error){
				trace(ex.getStackTrace());
			}
				
				
		}
		
		
		private function playGame(e:Event):void {
			try{
					if(0==playing){
						if(queueTwo.l%5==0&&queueTwo.l>0){
							level++;
							lblLevel.htmlText="Level:"+level;
						}
						
						btn_TopLeft.enabled=false;
						btn_TopRight.enabled=false;
						btn_BottomLeft.enabled=false;
						btn_BottomRight.enabled=false;
						myTimer = new Timer(Constants.TIMER/level,1);
						myTimerB = new Timer(Constants.TIMER/level,1);
						
						myTimer.addEventListener(TimerEvent.TIMER,computerMoveB);
						myTimerB.addEventListener(TimerEvent.TIMER,computerMove);						
						stage.removeEventListener(Event.ENTER_FRAME, playGame);
						
						if(queueTwo.empty){
							numeroAleatorio = Math.floor(Math.random() * ( Constants.MAX - Constants.MIN + 1) ) + Constants.MIN;
							trace("entra:"+numeroAleatorio);
							toggleButton(numeroAleatorio);
							queueTwo.write(numeroAleatorio);
							playSound(numeroAleatorio);	
						}
						myTimer.start();		
							
						
							
							
				}else if(1==playing){
					
					stage.removeEventListener(Event.ENTER_FRAME, playGame);
					btn_TopLeft.enabled=true;
						btn_TopRight.enabled=true;
						btn_BottomLeft.enabled=true;
						btn_BottomRight.enabled=true;
						btn_TopLeft.selected=false;
						btn_TopRight.selected=false;
						btn_BottomLeft.selected=false;
						btn_BottomRight.selected=false;
						
						
						
					
				}else{
					stage.removeEventListener(Event.ENTER_FRAME, playGame);
				}
			}catch(ex:Error){
				trace(ex.getStackTrace());
			}
			
		}
		
		private function computerMove(e:Event){
				if(queueOne.empty){
					 trace("hello");
					 playing=1;
					 queueOne=queueTwo.clone();
					 stage.addEventListener(Event.ENTER_FRAME, playGame);
					 soundChannel.stop();
					 
				}else{
					var tempo:int = queueOne.read();
					toggleButton(tempo);
					myTimer.start();
				}
			
		}
		
		private function computerMoveB(e:Event){
				if(1==queueTwo.l && firstRound){
					firstRound=false;
					myTimerB.start();
					return;
				}
					
				if(queueOne.empty){	
							numeroAleatorio = Math.floor(Math.random() * ( Constants.MAX - Constants.MIN + 1) ) + Constants.MIN;
							trace("entra:"+numeroAleatorio);
							toggleButton(numeroAleatorio);
							queueTwo.write(numeroAleatorio);
							playSound(numeroAleatorio);		
							myTimerB.start();	
								
							
							
							
			}else{
						trace("Spy:"+queueOne.spy());
						toggleButton(queueOne.spy());
						playSound(queueOne.spy());	
						myTimerB.start();
						
						
					
			}
				
		}
		
		
		private function playerMove(e:Event,index:int):void {
			
				trace(queueOne.spy());
				
			
								
			 if(queueOne.read()==index){		
					playSound(index);
					pointsInt+=(level*30);
						points.text="Points:"+pointsInt;
					if(queueOne.empty){
						
						playing=0;
						queueOne=queueTwo.clone();	
						stage.addEventListener(Event.ENTER_FRAME, playGame);
					}
					
			}else{
				playSound(-1);
				playing=-1;
				var myDialog:AlertDialog = new AlertDialog();
				myDialog.title = "GAME OVER";
				myDialog.message = "Your Score:"+pointsInt+"\nYour level:"+level+"\nPlay Again?";
				myDialog.dialogSize = DialogSize.SIZE_MEDIUM;
				myDialog.addButton("Yes");
				myDialog.addButton("No");
				myDialog.addEventListener(Event.SELECT, function(evt:Event){
						var pressed:int = (evt.target as AlertDialog).selectedIndex;
					
						if(0==pressed){
							
								
							btn_TopLeft.enabled=false;
							btn_TopRight.enabled=false;
							btn_BottomLeft.enabled=false;
							btn_BottomRight.enabled=false;
							
							interGameTimer.addEventListener(TimerEvent.TIMER,function(evt:Event){
								
								pointsInt=0;
								queueOne=new Queue();
								queueTwo=new Queue();
								stage.addEventListener(Event.ENTER_FRAME, playGame);
								firstRound=true;
								playing=0;
								points.text="Points:"+pointsInt;
								level=1;
								soundChannel.stop();
								lblLevel.htmlText="Level:"+level;
									(evt.target as AlertDialog).cancel();
										},false, 0, true);
							
									interGameTimer.start();
							
							
						}else{
							stage.nativeWindow.close();
						}
						
						
					},false, 0, true);
				
				myDialog.align = DialogAlign.TOP;
				myDialog.show(IowWindow.getAirWindow().group);
				
			}
		}
		
		
		private function toggleButton( index:int ):void {
		
			switch(index){
					case 0:
					 btn_TopLeft.selected = btn_TopLeft.selected ? false : true;
					 break;
					case 1:
					 btn_TopRight.selected = btn_TopRight.selected ? false : true;
					 break;
					case 2:
					 btn_BottomLeft.selected = btn_BottomLeft.selected ? false : true;
					 break;
					case 3:
					 btn_BottomRight.selected = btn_BottomRight.selected ? false : true;
					 break;
					
			}

			
			
		}
		
		
		
		}
		
	}

